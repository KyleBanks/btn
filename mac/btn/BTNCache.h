//
//  BTNCache.h
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTNAction.h"

@class BTNApplication;
@class BTNScript;

@interface BTNCache : NSObject

+(BTNCache *)sharedCache;


-(BTNAction)preferredAction;
-(void)setPreferredAction:(BTNAction)preferredAction;

-(BTNApplication *)selectedApplication;
-(void)setSelectedApplication:(BTNApplication *)selectedApplication;

-(BTNScript *)selectedScript;
-(void)setSelectedScript:(BTNScript *)selectedScript;

-(NSMutableArray *)selectedURLs;
-(void)setSelectedURLS:(NSArray *)selectedURLs;

@end
