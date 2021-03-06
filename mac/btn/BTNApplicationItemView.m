//
//  BTNApplicationItemView.m
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNApplicationItemView.h"
#import "BTNApplication.h"
#import "BTNAppDelegate.h"
#import "BTNCache.h"
#import "NSTextFieldCell+VerticalAlign.h"

@implementation BTNApplicationItemView

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
    
    self.txtDisplayName.stringValue = self.application.displayName;
    [[self.txtDisplayName cell] setLineBreakMode:NSLineBreakByTruncatingTail];
    self.imgImage.image = self.application.image;
    
    if([[BTNCache sharedCache].selectedApplications containsObject:self.application]) {
        [self.imgSelected setImage:[NSImage imageNamed:@"checkmark"]];
    } else {
        [self.imgSelected setImage:nil];
    }
    
    [self addCursorRect:self.frame cursor:[NSCursor pointingHandCursor]];
}
-(void)mouseDown:(NSEvent *)theEvent {
    [self.delegate application:self.application wasClicked:theEvent];
}

@end
