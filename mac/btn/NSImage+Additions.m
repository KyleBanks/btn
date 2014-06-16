//
//  NSImage+Additions.m
//  btn
//
//  Created by Kyle Banks on 2014-06-16.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "NSImage+Additions.h"

@implementation NSImage (Additions)

- (NSImage *)withNewSize:(NSSize)newSize {
    NSImage *sourceImage = self;
    [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid]) {
        NSLog(@"Invalid Image!");
    } else {
        NSImage *smallImage = [[NSImage alloc] initWithSize:newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:NSRectFromCGRect(CGRectMake(0, 0, newSize.width, newSize.height)) operation:NSCompositeCopy fraction:1.0f];
        
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}
- (NSImage *) scaledToHeight:(CGFloat)newHeight {
    CGFloat newWidth = (newHeight/self.size.height) * self.size.width;
    NSLog(@"New Width: %f", newWidth);
    
    return [self withNewSize:NSSizeFromCGSize(CGSizeMake(newWidth, newHeight))];
}

-(NSImage *)rotatedByDegrees:(double)degrees {
	// Calculate the bounds for the rotated image
	// We do this by affine-transforming the bounds rectangle
	NSRect imageBounds = {NSZeroPoint, [self size]};
	NSBezierPath* boundsPath = [NSBezierPath bezierPathWithRect:imageBounds];
	NSAffineTransform* transform = [NSAffineTransform transform];
	[transform rotateByDegrees:degrees];
	[boundsPath transformUsingAffineTransform:transform];
	NSRect rotatedBounds = {NSZeroPoint, [boundsPath bounds].size};
	NSImage* rotatedImage = [[NSImage alloc] initWithSize:rotatedBounds.size];
    
	// Center the image within the rotated bounds
	imageBounds.origin.x = NSMidX(rotatedBounds) - (NSWidth(imageBounds) / 2);
	imageBounds.origin.y = NSMidY(rotatedBounds) - (NSHeight(imageBounds) / 2);
    
	// Start a new transform, to transform the image
	transform = [NSAffineTransform transform];
    
	// Move coordinate system to the center
	// (since we want to rotate around the center)
	[transform translateXBy:+(NSWidth(rotatedBounds) / 2)
						yBy:+(NSHeight(rotatedBounds) / 2)];
	// Do the rotation
	[transform rotateByDegrees:degrees];
	// Move coordinate system back to normal (bottom, left)
	[transform translateXBy:-(NSWidth(rotatedBounds) / 2)
						yBy:-(NSHeight(rotatedBounds) / 2)];
    
	// Draw the original image, rotated, into the new image
	// Note: This "drawing" is done off-screen.
	[rotatedImage lockFocus];
	[transform concat];
	[self drawInRect:imageBounds fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0] ;
	[rotatedImage unlockFocus];
    
	return rotatedImage;
}
@end
