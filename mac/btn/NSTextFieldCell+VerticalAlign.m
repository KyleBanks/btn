//
//  NSTextFieldCell+VerticalAlign.m
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "NSTextFieldCell+VerticalAlign.h"

@implementation NSTextFieldCell (VerticalAlign)

- (NSRect) titleRectForBounds:(NSRect)frame {
    if (self.isEditable) {
        return [super titleRectForBounds:frame];
    }
    CGFloat stringHeight       = self.attributedStringValue.size.height;
    NSRect titleRect          = [super titleRectForBounds:frame];
    titleRect.origin.y = frame.origin.y +
    (frame.size.height - stringHeight) / 2.0;
    return titleRect;
}
- (void) drawInteriorWithFrame:(NSRect)cFrame inView:(NSView*)cView {
    if(self.isEditable) {
        return [super drawInteriorWithFrame:cFrame inView:cView];
    }
    
    [super drawInteriorWithFrame:[self titleRectForBounds:cFrame] inView:cView];
}

@end
