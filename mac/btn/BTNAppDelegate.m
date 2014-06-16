//
//  BTNAppDelegate.m
//  btn
//
//  Created by Kyle Banks on 2014-06-15.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNAppDelegate.h"
#import "BTNGateway.h"

@implementation BTNAppDelegate
{
    BTNGateway *gateway;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    gateway = [BTNGateway sharedGateway];
}

@end
