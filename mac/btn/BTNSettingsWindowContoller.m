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
{
    NSAlert *clearAllWarningAlert;
}

-(id)initWithWindowNibName:(NSString *)windowNibName {
    if(self = [super initWithWindowNibName:windowNibName]) {

    }
    return self;
}

-(void)windowDidLoad {
    [super windowDidLoad];
    [self.cmdClearActions setTarget:self];
    [self.cmdClearActions setAction:@selector(clearActionsWarning)];
    
    [self.cmdClearApplications setTarget:self];
    [self.cmdClearApplications setAction:@selector(clearApplications)];
    [self.cmdClearURLs setTarget:self];
    [self.cmdClearURLs setAction:@selector(clearURLs)];
    [self.cmdClearScript setTarget:self];
    [self.cmdClearScript setAction:@selector(clearScript)];
    
    [self.cmdSimulateClick setTarget:self];
    [self.cmdSimulateClick setAction:@selector(simulateBTNClick)];
    
    [self reloadActionCounts];
}

#pragma mark - UI 
-(void)reloadActionCounts {
    BTNCache *cache = [BTNCache sharedCache];
    self.countApplications.title = [NSString stringWithFormat:@"%ld", cache.selectedApplications.count];
    self.countUrls.title = [NSString stringWithFormat:@"%ld", cache.selectedURLs.count];
    self.countScripts.title = cache.selectedScript == nil ? @"0":@"1";
}

#pragma mark - Clear Actions
-(void)clearActionsWarning {
    clearAllWarningAlert = [[NSAlert alloc] init];
    [clearAllWarningAlert setMessageText:@"Confirm"];
    [clearAllWarningAlert setInformativeText:@"Are you sure you want to clear all actions?"];
    [clearAllWarningAlert setAlertStyle:NSCriticalAlertStyle];
    [clearAllWarningAlert addButtonWithTitle:@"Clear Actions"];
    [clearAllWarningAlert addButtonWithTitle:@"Cancel"];

    [clearAllWarningAlert beginSheetModalForWindow:self.window
                                     modalDelegate:self
                                    didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                                       contextInfo:nil];
}
-(void)clearApplications {
    [[BTNCache sharedCache] clearSelectedApplications];
    [self reloadActionCounts];
}
-(void)clearURLs {
    [[BTNCache sharedCache] clearSelectedURLs];
    [self reloadActionCounts];
}
-(void)clearScript {
    [[BTNCache sharedCache] clearSelectedScript];
    [self reloadActionCounts];
}

#pragma mark - Simulate Click
-(void)simulateBTNClick {
    [[BTNGateway sharedGateway] simulateBTNPress];
}

#pragma mark - AlertView Button Selector
- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if(alert == clearAllWarningAlert) {
        if(returnCode == NSAlertFirstButtonReturn) {
            [[BTNCache sharedCache] clearAllActionCaches];
            [self reloadActionCounts];
        }
        clearAllWarningAlert = nil;
    }
}

@end
