//
//  BTNCache.m
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNCache.h"
#import "BTNApplication.h"
#import "BTNScript.h"

NSString * const kSELECTED_APPLICATION = @"btn-selected-application-4";
NSString * const kSELECTED_SCRIPT = @"btn-selected-script-2";
NSString * const kSELECTED_URLS = @"btn-selected-urls";

static BTNCache *sharedCache;

@implementation BTNCache
{
    NSMutableArray *selectedApplications;
    BTNScript *selectedScript;
    NSMutableArray *selectedURLs;
}

#pragma mark - Singleton initialization
-(id)init {
    if(self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSData *selectedApplicationData = [defaults objectForKey:kSELECTED_APPLICATION];
        if(selectedApplicationData) {
            selectedApplications = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:selectedApplicationData]];
            NSLog(@"Found serialized Selected Applications: %ld", self.selectedApplications.count);
        } else {
            selectedApplications = [[NSMutableArray alloc] init];
        }
        
        NSData *selectedScriptData = [defaults objectForKey:kSELECTED_SCRIPT];
        if(selectedScriptData) {
            selectedScript = [NSKeyedUnarchiver unarchiveObjectWithData:selectedScriptData];
            NSLog(@"Found serialized Selected Script: %@", self.selectedScript.path.path);
        }
        
        NSData *selectedURLData = [defaults objectForKey:kSELECTED_URLS];
        if(selectedURLData) {
            selectedURLs = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:selectedURLData]];
            NSLog(@"Found %ld cached Selected URLs", self.selectedURLs.count);
        } else {
            selectedURLs = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

+(BTNCache*)sharedCache {
    if(!sharedCache) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        sharedCache = [[BTNCache alloc] init];
    }
    
    return sharedCache;
}

#pragma mark - Selected Application cache
-(void)setSelectedApplications:(NSMutableArray *)theSelectedApplications {
    if(theSelectedApplications) {
        NSLog(@"Serializing Selected Applications: %ld", theSelectedApplications.count);
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:theSelectedApplications];
        [self cacheData:data forKey:kSELECTED_APPLICATION];
    } else {
        [self clearCacheForKey:kSELECTED_APPLICATION];
    }
    selectedApplications = theSelectedApplications;
}
-(NSMutableArray *)selectedApplications {
    return selectedApplications;
}

#pragma mark - Selected Script cache
-(void)setSelectedScript:(BTNScript *)theSelectedScript {
    if(theSelectedScript) {
        NSLog(@"Serializing Selected Script: %@", theSelectedScript.path.path);
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:theSelectedScript];
        [self cacheData:data forKey:kSELECTED_SCRIPT];
    } else {
        [self clearCacheForKey:kSELECTED_SCRIPT];
    }
    selectedScript = theSelectedScript;
}
-(BTNScript *)selectedScript {
    return selectedScript;
}

#pragma mark - Selected URLs cache
-(void)setSelectedURLS:(NSArray *)theSelectedURLs {
    if(theSelectedURLs) {
        NSLog(@"Serializing %ld Selected URLs", theSelectedURLs.count);
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:theSelectedURLs];
        [self cacheData:data forKey:kSELECTED_URLS];
    }
    
    selectedURLs = [[NSMutableArray alloc] initWithArray:theSelectedURLs];
}
-(NSMutableArray *)selectedURLs {
    return selectedURLs;
}

#pragma mark - Caching helper methods, internal only
-(void)cacheData:(NSData *)data forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:key];
    [defaults synchronize];
}
-(void)clearCacheForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}


@end
