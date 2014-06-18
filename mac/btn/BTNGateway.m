//
//  BTNGateway.m
//  btn
//
//  Created by Kyle Banks on 2014-06-15.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNGateway.h"
#import "ORSSerialPortManager.h"

static BTNGateway *singleton = nil;

NSInteger const SERIAL_COMM_SPEED = 9600;
NSInteger const SERIAL_COMM_DELAY_AFTER_CONNECTION = 2; //Seconds to wait before sending data after the serial port connects
NSInteger const SERIAL_COMM_PORT_SCAN_INTERVAL = 4; //How often to scan for BTN connections when btn is disconnected
NSString * const SERIAL_COMM_MSG_PING = @"btnping";
NSString * const SERIAL_COMM_MSG_PONG = @"btnpong";
NSString * const SERIAL_COMM_MSG_BTN_PRESSED = @"btnpressed";
NSString * const SERIAL_COMM_MSG_STOP = @";";

@implementation BTNGateway
{
    NSMutableArray *delegates;
    
    NSMutableDictionary *serialInputBuffers; //Maps the NSString path of a serial port to the NSMutableData it has received
    ORSSerialPort *btnSerialPort;
}

#pragma mark - Singleton initialization
-(id) initSingleton {
    if(self = [super init]) {
        delegates = [[NSMutableArray alloc] init];
        serialInputBuffers = [[NSMutableDictionary alloc] init];
        
        [self scanSerialPorts];
    }
    return self;
}

+(BTNGateway *)sharedGateway {
    if (!singleton) {
        singleton = [[BTNGateway alloc] initSingleton];
    }
    
    return singleton;
}

# pragma mark - Delegate management
-(void)addDelegate:(id<BTNGatewayDelegate>)delegate {
    [delegates addObject:delegate];
}
+(void)addBtnGatewayDelegate:(id<BTNGatewayDelegate>)delegate {
    BTNGateway *gateway = [BTNGateway sharedGateway];
    [gateway addDelegate:delegate];
}

#pragma mark - Discovery
-(void)scanSerialPorts {
    if(btnSerialPort) {
        return;
    }
    
    ORSSerialPortManager *manager = [ORSSerialPortManager sharedSerialPortManager];
    for(ORSSerialPort *port in [manager availablePorts]) {
        [port setBaudRate:[NSNumber numberWithInt:SERIAL_COMM_SPEED]];
        [port setDelegate:self];
        
        if(!port.isOpen) {
            [port open];
        }
        
        [port performSelector:@selector(sendData:)
                   withObject:[[NSString stringWithFormat:@"%@%@", SERIAL_COMM_MSG_PING, SERIAL_COMM_MSG_STOP] dataUsingEncoding:NSUTF8StringEncoding]
                   afterDelay:SERIAL_COMM_DELAY_AFTER_CONNECTION];
    }

    [self performSelector:@selector(scanSerialPorts)
               withObject:nil
               afterDelay:SERIAL_COMM_PORT_SCAN_INTERVAL];
}

# pragma mark - Shutdown
-(void)disconnectBTN {
    if(btnSerialPort && [btnSerialPort isOpen]) {
        [btnSerialPort close];
    }
}

# pragma mark - Serial command processing
-(BOOL)processCommand:(NSString *)command forSerialPort:(ORSSerialPort *)serialPort {    
    if([command isEqualToString:SERIAL_COMM_MSG_PONG]) {
        NSLog(@"BTN found! %@", serialPort.path);
        btnSerialPort = serialPort;
        
        for (id<BTNGatewayDelegate> delegate in delegates) {
            [delegate btnGateway:self didInitializeBTN:btnSerialPort];
        }
        return YES;
    } else if([serialPort.path isEqualToString:btnSerialPort.path]) {
        if([command isEqualToString:SERIAL_COMM_MSG_BTN_PRESSED]) {
            NSLog(@"BTN pressed");
            
            for (id<BTNGatewayDelegate> delegate in delegates) {
                [delegate btnGateway:self didReceiveCommand:BTN_PRESSED];
            }
            return YES;
        }
    }
    return NO;
}

// Checks if the NSData received from a particular serialPort has ended (ie. the full data has been received)
-(BOOL)processSerialDataForPort:(ORSSerialPort *)serialPort {
    NSString *receivedData = [[NSString alloc] initWithData:[serialInputBuffers objectForKey:serialPort.path]
                                                   encoding:NSUTF8StringEncoding];
    
    if ([receivedData rangeOfString:SERIAL_COMM_MSG_STOP].location != NSNotFound) {
        NSArray *receivedCommands = [receivedData componentsSeparatedByString:SERIAL_COMM_MSG_STOP];
        NSString *command = [receivedCommands objectAtIndex:0];
        [self processCommand:command forSerialPort:serialPort];
        
        // If there is still data after the FIRST stop command, put it back into the serialInputBuffers. Else, create a new buffer
        if(receivedCommands.count > 1) {
            [serialInputBuffers setValue:[[receivedCommands objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding] forKey:serialPort.path];
        } else {
            [serialInputBuffers setValue:[[NSMutableData alloc] init] forKey:serialPort.path];
        }
        
        return YES;
    }

    return NO;
}

#pragma mark - ORSSerialPortDelegate
- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data {
    if(data.length == 0) {
        NSLog(@"Ignoring illegal input from Serial Port %@...", serialPort.path);
        return;
    }

    NSMutableData *dataBuffer = [serialInputBuffers objectForKey:serialPort.path];
    if(!dataBuffer) {
        dataBuffer = [[NSMutableData alloc] init];
    }
    [dataBuffer appendData:data];
    [serialInputBuffers setObject:dataBuffer forKey:serialPort.path];
    
    if([self processSerialDataForPort:serialPort]) {
       // NSLog(@"Data processed for Serial Port: %@", serialPort.path);
    }
}
- (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort {
    NSLog(@"Serial Port [%@] removed from system...", serialPort.path);
    [serialPort close];
    
    if([serialPort.path isEqualToString:btnSerialPort.path]) {
        btnSerialPort = nil;
        [self scanSerialPorts];
        for (id<BTNGatewayDelegate> delegate in delegates) {
            [delegate btnGateway:self lostConnectionToBTN:btnSerialPort];
        }
    }
}
-(void)serialPortWasOpened:(ORSSerialPort *)serialPort {
    NSLog(@"Serial Port [%@] was opened...", serialPort.path);
}
-(void)serialPort:(ORSSerialPort *)serialPort didEncounterError:(NSError *)error {
    if([serialPort.path isEqualToString:btnSerialPort.path]) {
        NSLog(@"BTN [%@] encountered error: %@", serialPort.path, error.description);

        for (id<BTNGatewayDelegate> delegate in delegates) {
            [delegate btnGateway:self didEncounterError:error];
        }
    }
}
-(void)serialPortWasClosed:(ORSSerialPort *)serialPort {
    NSLog(@"Serial Port [%@] was closed...", serialPort.path);
}

#pragma mark - Testing Only
-(void)simulateBTNPress {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    for (id<BTNGatewayDelegate> delegate in delegates) {
        [delegate btnGateway:self didReceiveCommand:BTN_PRESSED];
    }
}

@end
