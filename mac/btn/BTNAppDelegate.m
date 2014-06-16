//
//  BTNAppDelegate.m
//  btn
//
//  Created by Kyle Banks on 2014-06-15.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNAppDelegate.h"

@implementation BTNAppDelegate
{
    BTNGateway *gateway;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [BTNGateway addBtnGatewayDelegate:self];
}


#pragma mark - Temporary, just checking delegate functions are called correctly
-(void)btnGateway:(BTNGateway *)gateway didInitializeBTN:(ORSSerialPort *)btnSerialPort {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}
-(void)btnGateway:(BTNGateway *)gateway didReceiveCommand:(BTNCommand)command {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}
-(void)btnGateway:(BTNGateway *)gateway lostConnectionToBTN:(ORSSerialPort *)btnSerialPort {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}
-(void)btnGateway:(BTNGateway *)gateway didEncounterError:(NSError *)error {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}

@end
