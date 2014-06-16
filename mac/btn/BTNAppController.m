//
//  BTNAppController.m
//  btn
//
//  Created by Kyle Banks on 2014-06-16.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNAppController.h"
#import "NSImage+Additions.h"

NSInteger const CONNSTATUS_DISCONNECTED = 0;
NSInteger const CONNSTATUS_CONNECTED = 1;
NSInteger const CONNSTATUS_CONNECTING = 2;

@implementation BTNAppController
{
    NSStatusItem *statusItem;
    
    int connectionStatus;
    NSDictionary *statusIconMap;
}

-(id)init {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    if(self = [super init]) {
        connectionStatus = CONNSTATUS_CONNECTING;
        
        statusIconMap = @{
            [NSNumber numberWithInt:CONNSTATUS_CONNECTED]: [[NSImage imageNamed:@"connstatus_connected"] scaledToHeight:19.0f],
            [NSNumber numberWithInt:CONNSTATUS_DISCONNECTED]: [[NSImage imageNamed:@"connstatus_disconnected"] scaledToHeight:19.0f],
            [NSNumber numberWithInt:CONNSTATUS_CONNECTING]: [[NSImage imageNamed:@"connstatus_connecting"] scaledToHeight:19.0f]
        };
        
        NSNib *nib = [[NSNib alloc] initWithNibNamed:@"MainMenu" bundle:[NSBundle mainBundle]];
        NSArray *topLevelObjects;
        if (![nib instantiateWithOwner:self topLevelObjects:&topLevelObjects]) {
            NSLog(@"ERROR: Unable to initialize BTNAppController");
        } else {
            NSLog(@"BTNAppController initialized.");
        }
        
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(updateStatusBarIcon)
                                       userInfo:nil
                                        repeats:YES];
    }
    
    return self;
}

-(void)awakeFromNib {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:self.statusMenu];
    [statusItem setHighlightMode:YES];
   // menuView = [[BTNMenuView alloc] initWithStatusItem:statusItem];
    
}

-(void)setBTNConnected:(BOOL)isConnected {
    if(isConnected) {
        connectionStatus = CONNSTATUS_CONNECTED;
    } else {
        connectionStatus = CONNSTATUS_DISCONNECTED;
    }
}

-(void)updateStatusBarIcon {
    NSImage *image = [statusIconMap objectForKey:[NSNumber numberWithInt:connectionStatus]];
    [statusItem setImage:image];
}
@end
