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


-(NSMutableArray *)selectedApplications;
-(void)setSelectedApplications:(NSMutableArray *)selectedApplications;

-(BTNScript *)selectedScript;
-(void)setSelectedScript:(BTNScript *)selectedScript;

-(NSMutableArray *)selectedURLs;
-(void)setSelectedURLs:(NSArray *)selectedURLs;

-(void)clearSelectedApplications;
-(void)clearSelectedURLs;
-(void)clearSelectedScript;
-(void)clearAllActionCaches;

@end
