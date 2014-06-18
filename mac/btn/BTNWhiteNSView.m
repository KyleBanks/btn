//
//  BTNWhiteNSView.m
//  btn
//
//  Created by Kyle Banks on 2014-06-18.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNWhiteNSView.h"

double const BORDER_WIDTH = 1.0;

@implementation BTNWhiteNSView

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
    
    //Background color
    [[NSColor whiteColor] set];
    NSRectFill([self bounds]);
    
    //Border
    NSRect frameRect = [self bounds];
    if(dirtyRect.size.height < frameRect.size.height) {
        return;
    }
    
    NSRect newRect = NSMakeRect(dirtyRect.origin.x+BORDER_WIDTH,
                                dirtyRect.origin.y+BORDER_WIDTH,
                                dirtyRect.size.width-(BORDER_WIDTH*2),
                                dirtyRect.size.height-(BORDER_WIDTH*2));
    
    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:newRect
                                                               xRadius:0
                                                               yRadius:0];
    [borderPath setLineWidth:BORDER_WIDTH];
    [[NSColor darkGrayColor] set];
    [borderPath stroke];
}

@end
