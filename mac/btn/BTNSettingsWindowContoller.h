//
//  BTNSettingsWindowContoller.h
//  btn
//
//  Created by Kyle Banks on 2014-06-18.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTNSettingsWindowContoller : NSWindowController

@property (weak) IBOutlet NSView *clearActionsWrapper;
@property (weak) IBOutlet NSButton *cmdClearActions;
@property (weak) IBOutlet NSButton *cmdClearApplications;
@property (weak) IBOutlet NSButton *cmdClearURLs;
@property (weak) IBOutlet NSButton *cmdClearScript;

@property (weak) IBOutlet NSButton *countApplications;
@property (weak) IBOutlet NSButton *countUrls;
@property (weak) IBOutlet NSButton *countScripts;

@property (weak) IBOutlet NSButton *cmdSimulateClick;

@end
