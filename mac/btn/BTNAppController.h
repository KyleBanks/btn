//
//  BTNAppController.h
//  btn
//
//  Created by Kyle Banks on 2014-06-16.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTNAppController : NSObject

@property (strong) IBOutlet NSMenu *statusMenu;

-(id)initWithWindow:(NSWindow *)window;

-(void)setBTNConnected:(BOOL)isConnected;

@end
