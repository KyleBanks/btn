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
#import "NSTextFieldCell+VerticalAlign.h"

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
        [self.chkShowOutput setState:cache.selectedScript.showOutput ? NSOnState: NSOffState];
        [self.chkShowOutput setEnabled:YES];
    } else {
        self.lblScriptPath.stringValue = @"No script selected.";
        self.chkShowOutput.state = NSOffState;
        [self.chkShowOutput setEnabled:NO];
    }
    
    self.chkShowOutput.target = self;
    self.chkShowOutput.action = @selector(toggleShowOutput);
}

-(void)cmdSelectScriptClicked {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    [self displayFilePicker];
}

-(void)displayFilePicker {
    self.fileDialog = [NSOpenPanel openPanel];
    
    [self.fileDialog setPrompt:@"Select"];
    [self.fileDialog setTitle:@"Select Script (.sh)"];
    [self.fileDialog setAllowedFileTypes:@[@"sh"]];
    [self.fileDialog setAllowsMultipleSelection:NO];
    
    BTNCache *cache = [BTNCache sharedCache];
    NSURL *selectedScript = cache.selectedScript.path;
    if(selectedScript) {
        [self.fileDialog setDirectoryURL:selectedScript];
    }
    
    if([self.fileDialog runModal] == NSFileHandlingPanelOKButton) {
        NSURL *scriptPath = [[self.fileDialog URLs] objectAtIndex:0];
        if(scriptPath) {
            NSLog(@"User selected Shell Script: %@", scriptPath.path);

            
            BTNScript *newScript = [[BTNScript alloc] initWithPath:scriptPath];
            newScript.showOutput = (self.chkShowOutput.state == NSOnState);
            [self.delegate btnExecuteScriptView:self
                                didSelectScript:newScript];
        }

    }
}

-(void)toggleShowOutput {
    BOOL showOutput = NO;
    if(self.chkShowOutput.state == NSOffState) {
        self.chkShowOutput.state = NSOnState;
        showOutput = YES;
    } else {
        self.chkShowOutput.state = NSOffState;
        showOutput = NO;
    }
    [self.chkShowOutput setNeedsDisplay];
    
    BTNCache *cache = [BTNCache sharedCache];
    BTNScript *script = cache.selectedScript;
    script.showOutput = showOutput;
    [self.delegate btnExecuteScriptView:self
                        didSelectScript:script];
}

@end
