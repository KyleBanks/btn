//
//  BTNAppController.m
//  btn
//
//  Created by Kyle Banks on 2014-06-16.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNAppController.h"

NSString * const CONNECTED_TEXT = @"BTN - Connected";
NSString * const DISCONNECTED_TEXT = @"BTN - Disonnected";

@implementation BTNAppController
{
    NSWindow *window;
    NSStatusItem *statusItem;
}
@synthesize statusMenu;

-(id)initWithWindow:(NSWindow *)theWindow {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    if(self = [super init]) {
        window = theWindow;
        
        NSNib *nib = [[NSNib alloc] initWithNibNamed:@"MainMenu" bundle:[NSBundle mainBundle]];
        NSArray *topLevelObjects;
        if (![nib instantiateWithOwner:self topLevelObjects:&topLevelObjects]) {
            NSLog(@"ERROR: Unable to initialize BTNAppController");
        } else {
            NSLog(@"BTNAppController initialized.");
        }
    }
    
    return self;
}

-(void)awakeFromNib {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:DISCONNECTED_TEXT];
    [statusItem setHighlightMode:YES];
}

-(void)setBTNConnected:(BOOL)isConnected {
    if(isConnected) {
        [statusItem setTitle:CONNECTED_TEXT];
    } else {
        [statusItem setTitle:DISCONNECTED_TEXT];
    }
}
@end
