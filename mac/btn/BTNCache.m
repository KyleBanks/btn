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

NSString * const kSELECTED_APPLICATIONS = @"btn-selected-application-5";
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
        NSData *selectedApplicationData = [NSData dataWithContentsOfFile:[self getCachePathForKey:kSELECTED_APPLICATIONS]];
        if(selectedApplicationData) {
            selectedApplications = [[NSKeyedUnarchiver unarchiveObjectWithData:selectedApplicationData] mutableCopy];
            NSLog(@"Found serialized Selected Applications: %ld", self.selectedApplications.count);
        } else {
            selectedApplications = [[NSMutableArray alloc] init];
        }
        
        NSData *selectedScriptData = [NSData dataWithContentsOfFile:[self getCachePathForKey:kSELECTED_SCRIPT]];
        if(selectedScriptData) {
            selectedScript = [NSKeyedUnarchiver unarchiveObjectWithData:selectedScriptData];
            NSLog(@"Found serialized Selected Script: %@", self.selectedScript.path.path);
        }
        
        NSData *selectedURLData = [NSData dataWithContentsOfFile:[self getCachePathForKey:kSELECTED_URLS]];
        if(selectedURLData) {
            selectedURLs = [[NSKeyedUnarchiver unarchiveObjectWithData:selectedURLData] mutableCopy];
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
        [self cacheData:data forKey:kSELECTED_APPLICATIONS];
    } else {
        [self clearCacheForKey:kSELECTED_APPLICATIONS];
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
-(NSString *)getCachePathForKey:(NSString *)key {
    NSString *path = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if ([paths count])
    {
        NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];

        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSError *err;
            [[NSFileManager defaultManager] createDirectoryAtPath:path
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&err];
            
            if(err) {
                NSLog(@"ERROR: Unable to create cache directory structure for path[%@]: %@", path, err.localizedDescription);
            }
        }
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.cache", key]];
    }
    
    return path;
}
-(void)cacheData:(NSData *)data forKey:(NSString *)key {
    NSString *path = [self getCachePathForKey:key];
    
    if(path) {
        NSLog(@"Caching to path: %@", path);
        
        BOOL success = [[NSFileManager defaultManager] createFileAtPath:path
                                                               contents:data
                                                             attributes:nil];
        if (!success) {
            NSLog(@"Error writing cache at path[%@]...", path);
        }
    } else {
        NSLog(@"ERROR: Cannot find cache file path, unable to cache %@", key);
    }
}
-(void)clearCacheForKey:(NSString *)key {
    NSString *path = [self getCachePathForKey:key];
    
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (!success) {
            NSLog(@"Error removing cache at path[%@]: %@", path, error.localizedDescription);
        }
    }
}


@end
