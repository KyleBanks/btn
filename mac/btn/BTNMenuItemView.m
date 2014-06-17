//
//  BTNMenuItemView.m
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNMenuItemView.h"
#import "BTNCache.h"
#import "BTNActionHelper.h"

@implementation BTNMenuItemView

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
    
    if(self.representingAction == [BTNCache sharedCache].preferredAction) {
        [self.imgSelected setImage:[NSImage imageNamed:@"checkmark"]];
    } else {
        [self.imgSelected setImage:nil];
    }
    self.txtLabel.stringValue = [BTNActionHelper titleForBTNAction:self.representingAction];
}

@end
