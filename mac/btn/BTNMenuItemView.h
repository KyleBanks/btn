//
//  BTNMenuItemView.h
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BTNAction.h"

@interface BTNMenuItemView : NSView

@property (weak) IBOutlet NSTextField *txtLabel;
@property (weak) IBOutlet NSImageView *imgSelected;

@property BTNAction representingAction;

@end
