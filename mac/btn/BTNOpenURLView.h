//
//  BTNOpenURLView.h
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BTNOpenURLView : NSView <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tblURLs;
@property (weak) IBOutlet NSButton *cmdAddURL;
@property (weak) IBOutlet NSTextField *txtURLInput;

@end
