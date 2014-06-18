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
#import "NSTextFieldCell+VerticalAlign.h"

@implementation BTNMenuItemView
{
    BOOL mouseOver;
}

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
    
    if(mouseOver) {
        [[NSColor blueColor] setFill];
    } else {
        [[NSColor whiteColor] setFill];
    }
    NSRectFill(dirtyRect);
    
    self.txtLabel.stringValue = [BTNActionHelper titleForBTNAction:self.representingAction];
    
    BTNCache *cache = [BTNCache sharedCache];
    NSInteger count = 0;
    switch (self.representingAction) {
        case BTNActionExecuteScript:
            count = cache.selectedScript != nil ? 1 : 0;
            break;
        case BTNActionOpenApplication:
            count = cache.selectedApplications.count;
            break;
        case BTNActionOpenURL:
            count = cache.selectedURLs.count;
            break;
        case BTNActionSettings:
            count = 0;
            [self.imgArrow setHidden:YES];
            break;
        default:
            break;
    }
    
    
    if(count > 0) {
        self.btnItemCount.title = [NSString stringWithFormat:@"%ld", count];
        [self.btnItemCount setHidden:NO];
    } else {
        [self.btnItemCount setHidden:YES];
    }
}

// Calls the click action on the parent menu
- (void)mouseUp:(NSEvent*) event {
    NSMenuItem* mitem = [self enclosingMenuItem];
    NSMenu* m = [mitem menu];
    [m cancelTracking];
    [m performActionForItemAtIndex:[m indexOfItem: mitem]];
}

@end
