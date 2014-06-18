//
//  BTNSettingsWindowContoller.m
//  btn
//
//  Created by Kyle Banks on 2014-06-18.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNSettingsWindowContoller.h"
#import "BTNCache.h"

@implementation BTNSettingsWindowContoller

-(id)initWithWindowNibName:(NSString *)windowNibName {
    if(self = [super initWithWindowNibName:windowNibName]) {

    }
    return self;
}

-(void)windowDidLoad {
    [super windowDidLoad];
    [self.cmdClearActions setTarget:self];
    [self.cmdClearActions setAction:@selector(clearActionsWarning)];
}

#pragma mark - Clear Actions
-(void)clearActionsWarning {
    NSAlert *warningAlert = [[NSAlert alloc] init];
    [warningAlert setMessageText:@"Confirm"];
    [warningAlert setInformativeText:@"Are you sure you want to clear all actions?"];
    [warningAlert setAlertStyle:NSCriticalAlertStyle];
    [warningAlert addButtonWithTitle:@"Clear Actions"];
    [warningAlert addButtonWithTitle:@"Cancel"];

    [warningAlert beginSheetModalForWindow:self.window
                             modalDelegate:self
                            didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                               contextInfo:nil];
}

#pragma mark - AlertView Button Selector
- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if(returnCode == NSAlertFirstButtonReturn) {
        [[BTNCache sharedCache] clearAllActionCaches];
    }
}

@end
