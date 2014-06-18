//
//  BTNScript.h
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTNScript : NSObject <NSCoding>

@property NSURL *path;
@property BOOL showOutput;

-(id)initWithPath:(NSURL *)path;

-(NSString *)executeWithError:(NSError **)err;

@end
