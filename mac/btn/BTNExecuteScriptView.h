//
//  BTNExecuteScriptView.h
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BTNExecuteScriptView;
@class BTNScript;

@protocol BTNExecuteScriptViewProtocol <NSObject>
-(void)btnExecuteScriptView:(BTNExecuteScriptView *)executeScriptView didSelectScript:(BTNScript *)script;
@end

@interface BTNExecuteScriptView : NSView

@property (weak) IBOutlet NSTextField *lblScriptPath;
@property (weak) IBOutlet NSButton *cmdSelectScript;
@property (weak) IBOutlet NSButton *chkShowOutput;
@property id<BTNExecuteScriptViewProtocol> delegate;

@property (strong) NSOpenPanel *fileDialog;

@end
