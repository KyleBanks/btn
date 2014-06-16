//
//  BTNAppDelegate.m
//  btn
//
//  Created by Kyle Banks on 2014-06-15.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNAppDelegate.h"
#import "BTNAppController.h"

@implementation BTNAppDelegate
{
    BTNGateway *gateway;
    BTNAppController *appController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    appController = [[BTNAppController alloc] init];
    [BTNGateway addBtnGatewayDelegate:self];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    [[BTNGateway sharedGateway] disconnectBTN];
}


#pragma mark - BTNGatewayDelegate functionality
-(void)btnGateway:(BTNGateway *)gateway didInitializeBTN:(ORSSerialPort *)btnSerialPort {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    [appController setBTNConnected:YES];
}
-(void)btnGateway:(BTNGateway *)gateway didReceiveCommand:(BTNCommand)command {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    switch (command) {
        case BTN_PRESSED:
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://google.com"]];
            break;
        default:
            break;
    }
}
-(void)btnGateway:(BTNGateway *)gateway lostConnectionToBTN:(ORSSerialPort *)btnSerialPort {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    [appController setBTNConnected:NO];
}
-(void)btnGateway:(BTNGateway *)gateway didEncounterError:(NSError *)error {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}

@end
