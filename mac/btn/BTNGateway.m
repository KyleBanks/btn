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
NSString * const SERIAL_COMM_MSG_PING = @"btnping";
NSString * const SERIAL_COMM_MSG_PONG = @"btnpong";
NSString * const SERIAL_COMM_MSG_BTN_PRESSED = @"btnpressed";
NSString * const SERIAL_COMM_MSG_STOP = @"STOP";

@implementation BTNGateway
{
    NSMutableArray *delegates;
    
    NSDictionary *serialInputBuffers; //Maps the NSString path of a serial port to the NSMutableData it has received
    ORSSerialPort *btnSerialPort;
}

#pragma mark - Singleton initialization
-(id) initSingleton {
    if(self = [super init]) {
        delegates = [[NSMutableArray alloc] init];
        
        ORSSerialPortManager *manager = [ORSSerialPortManager sharedSerialPortManager];
        for(ORSSerialPort *port in [manager availablePorts]) {
            [serialInputBuffers setValue:[[NSMutableData alloc] init] forKey:port.path];

            [port setBaudRate:[NSNumber numberWithInt:SERIAL_COMM_SPEED]];
            [port setDelegate:self];

            if(!port.isOpen) {
                NSLog(@"Opening port %@", port.path);
                [port open];
            }
            //[port setShouldEchoReceivedData:YES];
            
            [port performSelector:@selector(sendData:)
                       withObject:[SERIAL_COMM_MSG_PING dataUsingEncoding:NSUTF8StringEncoding]
                       afterDelay:SERIAL_COMM_DELAY_AFTER_CONNECTION];
            
//            if(port.isOpen) {
//                [port close];
//            }
        }
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


# pragma mark - Shutdown
-(void)disconnectBTN {
    if(btnSerialPort && [btnSerialPort isOpen]) {
        [btnSerialPort close];
    }
}

# pragma mark - Serial command processing
-(BOOL)processCommand:(NSString *)command forSerialPort:(ORSSerialPort *)serialPort {
    NSLog(@"Response from port %@", serialPort.path);
    NSLog(@"Command: %@", command);
    
    if([command isEqualToString:SERIAL_COMM_MSG_PONG]) {
        NSLog(@"BTN found! %@", serialPort.path);
        btnSerialPort = serialPort;
        
        for (id<BTNGatewayDelegate> delegate in delegates) {
            [delegate btnGateway:self didInitializeBTN:btnSerialPort];
        }
        return YES;
    } else if([command isEqualToString:SERIAL_COMM_MSG_BTN_PRESSED]) {
        NSLog(@"BTN pressed");
        
        for (id<BTNGatewayDelegate> delegate in delegates) {
            [delegate btnGateway:self didReceiveCommand:BTN_PRESSED];
        }
        return YES;
    }
    
    return NO;
}

// Checks if the NSData received from a particular serialPort has ended (ie. the full data has been received)
-(BOOL)processSerialDataForPort:(ORSSerialPort *)serialPort {
    NSString *receivedData = [[NSString alloc] initWithData:[serialInputBuffers objectForKey:serialPort.path] encoding:NSUTF8StringEncoding];
    
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

    [[serialInputBuffers objectForKey:serialPort.path] appendData:data];
    if([self processSerialDataForPort:serialPort]) {
        NSLog(@"Data processed for Serial Port: %@", serialPort.path);
    }
}
- (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort {
    NSLog(@"Serial Port [%@] removed from system...", serialPort.path);
    [serialPort close];
    
    if([serialPort.path isEqualToString:btnSerialPort.path]) {
        for (id<BTNGatewayDelegate> delegate in delegates) {
            [delegate btnGateway:self lostConnectionToBTN:btnSerialPort];
        }
    }
}
-(void)serialPortWasOpened:(ORSSerialPort *)serialPort {
    NSLog(@"Serial Port [%@] was opened...", serialPort.path);
}
-(void)serialPort:(ORSSerialPort *)serialPort didEncounterError:(NSError *)error {
    NSLog(@"Serial Port [%@] encountered error: %@", serialPort.path, error.description);
    
    if([serialPort.path isEqualToString:btnSerialPort.path]) {
        for (id<BTNGatewayDelegate> delegate in delegates) {
            [delegate btnGateway:self didEncounterError:error];
        }
    }
}
-(void)serialPortWasClosed:(ORSSerialPort *)serialPort {
    NSLog(@"Serial Port [%@] was closed...", serialPort.path);
}

@end
