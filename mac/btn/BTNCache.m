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

NSString * const kPREFERRED_ACTION = @"btn-preferred-action";

NSString * const kSELECTED_APPLICATION = @"btn-selected-application";
NSString * const kSELECTED_SCRIPT = @"btn-selected-script-2";

static BTNCache *sharedCache;

@implementation BTNCache
{
    BTNAction preferredAction;

    BTNApplication *selectedApplication;
    BTNScript *selectedScript;
}

#pragma mark - Singleton initialization
-(id)init {
    if(self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSData *preferredActionData = [defaults objectForKey:kPREFERRED_ACTION];
        if(preferredActionData) {
            self.preferredAction = [[NSKeyedUnarchiver unarchiveObjectWithData:preferredActionData] integerValue];
            NSLog(@"Found serialized Preferred Action: %ld", self.preferredAction);
        } else {
            NSLog(@"Did not find a preferred action, setting to BTNActionDoNothing...");
            self.preferredAction = BTNActionDoNothing;
        }
        
        NSData *selectedApplicationData = [defaults objectForKey:kSELECTED_APPLICATION];
        if(selectedApplicationData) {
            self.selectedApplication = [NSKeyedUnarchiver unarchiveObjectWithData:selectedApplicationData];
            NSLog(@"Found serialized Selected Application: %@", self.selectedApplication.displayName);
        }
        
        NSData *selectedScriptData = [defaults objectForKey:kSELECTED_SCRIPT];
        if(selectedScriptData) {
            self.selectedScript = [NSKeyedUnarchiver unarchiveObjectWithData:selectedScriptData];
            NSLog(@"Found serialized Selected Script: %@", self.selectedScript.path.path);
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

#pragma mark - Preferred Action cache
-(void)setPreferredAction:(BTNAction)thePreferredAction {
    NSLog(@"Serializing Preferred Action: %ld", thePreferredAction);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInteger:thePreferredAction]];
    [self cacheData:data forKey:kPREFERRED_ACTION];
    
    preferredAction = thePreferredAction;
}

-(BTNAction)preferredAction {
    return preferredAction;
}

#pragma mark - Selected Application cache
-(void)setSelectedApplication:(BTNApplication *)theSelectedApplication {
    if(theSelectedApplication) {
        NSLog(@"Serializing Selected Application: %@", theSelectedApplication.displayName);
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:theSelectedApplication];
        [self cacheData:data forKey:kSELECTED_APPLICATION];
    }
    selectedApplication = theSelectedApplication;
}
-(BTNApplication *)selectedApplication {
    return selectedApplication;
}

#pragma mark - Selected Script cache
-(void)setSelectedScript:(BTNScript *)theSelectedScript {
    if(theSelectedScript) {
        NSLog(@"Serializing Selected Script: %@", theSelectedScript.path.path);
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:theSelectedScript];
        [self cacheData:data forKey:kSELECTED_SCRIPT];
    }
    selectedScript = theSelectedScript;
}
-(BTNScript *)selectedScript {
    return selectedScript;
}

#pragma mark - Caching helper methods, internal only
-(void)cacheData:(NSData *)data forKey:(NSString *)key {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:key];
    [defaults synchronize];
}


@end
