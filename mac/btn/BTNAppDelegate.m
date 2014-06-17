//
//  BTNAppDelegate.m
//  btn
//
//  Created by Kyle Banks on 2014-06-15.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNAppDelegate.h"
#import "BTNAppController.h"
#import "BTNApplication.h"

@implementation BTNAppDelegate
{
    BTNGateway *gateway;
    BTNAppController *appController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    NSData *selectedApplicationData = [[NSUserDefaults standardUserDefaults] objectForKey:kSELECTED_APPLICATION];
    if(selectedApplicationData) {
        self.selectedApplication = [NSKeyedUnarchiver unarchiveObjectWithData:selectedApplicationData];
        NSLog(@"Found serialized Selected Application: %@", self.selectedApplication.displayName);
    }
    
    appController = [[BTNAppController alloc] init];
    appController.appDelegate = self;
    [BTNGateway addBtnGatewayDelegate:self];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    [[BTNGateway sharedGateway] disconnectBTN];
    [self saveSelectedApplication];
}
-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *) sender{
    return YES;
}

-(void)saveSelectedApplication {
    if(self.selectedApplication) {
        NSLog(@"Serializing Selected Application: %@", self.selectedApplication.displayName);
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        NSData* notificationsData=[NSKeyedArchiver archivedDataWithRootObject:self.selectedApplication];
        [defaults setObject: notificationsData forKey:kSELECTED_APPLICATION];
        [defaults synchronize];
    }
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
            if(self.selectedApplication) {
                NSLog(@"Launching %@ (%@)...", self.selectedApplication.displayName, self.selectedApplication.path.path);
                NSRunningApplication * newApp = [[NSWorkspace sharedWorkspace] launchApplicationAtURL:self.selectedApplication.path
                                                              options:NSWorkspaceLaunchDefault
                                                        configuration:nil
                                                                error:nil];
                [newApp activateWithOptions: NSApplicationActivateAllWindows];
                
            }
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
