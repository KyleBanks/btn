//
//  BTNApplication.m
//  btn
//
//  Created by Kyle Banks on 2014-06-16.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNApplication.h"

@implementation BTNApplication

-(id)initWithDisplayName:(NSString *)displayName andPath:(NSURL *)path andImage:(NSImage *)image {
    if(self = [super init]) {
        self.displayName = displayName;
        self.path = path;
        self.image = image;
    }
    
    return self;
}

@end
