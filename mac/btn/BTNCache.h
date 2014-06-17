//
//  BTNCache.h
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTNApplication;

@interface BTNCache : NSObject

+(BTNCache *)sharedCache;

-(BTNApplication *)selectedApplication;
-(void)setSelectedApplication:(BTNApplication *)selectedApplication;

@end
