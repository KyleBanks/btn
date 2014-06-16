//
//  NSImage+Additions.h
//  btn
//
//  Created by Kyle Banks on 2014-06-16.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Additions)

- (NSImage *)withNewSize:(NSSize)newSize;
- (NSImage *)scaledToHeight:(CGFloat)newHeight;
- (NSImage *)rotatedByDegrees:(double)degrees;
@end
