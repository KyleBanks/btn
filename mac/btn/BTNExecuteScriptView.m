//
//  BTNExecuteScriptView.m
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNExecuteScriptView.h"
#import "BTNCache.h"
#import "BTNScript.h"

@implementation BTNExecuteScriptView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [self.cmdSelectScript setTarget:self];
    [self.cmdSelectScript setAction:@selector(cmdSelectScriptClicked)];
    
    BTNCache *cache = [BTNCache sharedCache];
    if(cache.selectedScript) {
        self.lblScriptPath.stringValue = cache.selectedScript.path.path;
    } else {
        self.lblScriptPath.stringValue = @"No script selected.";
    }
}

-(void)cmdSelectScriptClicked {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    [self displayFilePicker];
}

-(void)displayFilePicker {
    NSOpenPanel *fileDialog = [NSOpenPanel openPanel];
    
    [fileDialog setPrompt:@"Select"];
    [fileDialog setTitle:@"Select Script (.sh)"];
    [fileDialog setAllowedFileTypes:@[@"sh"]];
    [fileDialog setAllowsMultipleSelection:NO];
    
    BTNCache *cache = [BTNCache sharedCache];
    NSURL *selectedScript = cache.selectedScript.path;
    if(selectedScript) {
        [fileDialog setDirectoryURL:selectedScript];
    }
    
    if([fileDialog runModal] == NSFileHandlingPanelOKButton) {
        NSURL *scriptPath = [[fileDialog URLs] objectAtIndex:0];
        if(scriptPath) {
            NSLog(@"User selected Shell Script: %@", scriptPath.path);
            [self.delegate btnExecuteScriptView:self
                                didSelectScript:[[BTNScript alloc] initWithPath:scriptPath]];
        }

    }
}

@end
