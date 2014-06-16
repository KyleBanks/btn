//
//  BTNAppDelegate.h
//  btn
//
//  Created by Kyle Banks on 2014-06-15.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BTNGateway.h"

@interface BTNAppDelegate : NSObject <NSApplicationDelegate, BTNGatewayDelegate>

@property (assign) IBOutlet NSWindow *window;

@end
