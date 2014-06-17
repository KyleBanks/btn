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
    CGFloat stringHeight       = self.attributedStringValue.size.height;
    NSRect titleRect          = [super titleRectForBounds:frame];
    titleRect.origin.y = frame.origin.y +
    (frame.size.height - stringHeight) / 2.0;
    return titleRect;
}
- (void) drawInteriorWithFrame:(NSRect)cFrame inView:(NSView*)cView {
    [super drawInteriorWithFrame:[self titleRectForBounds:cFrame] inView:cView];
}

@end
