//
//  BTNCache.m
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNCache.h"
#import "BTNApplication.h"

static BTNCache *sharedCache;

@implementation BTNCache
{
    BTNApplication *selectedApplication;
}

#pragma mark - Singleton initialization
-(id)init {
    if(self = [super init]) {
        NSData *selectedApplicationData = [[NSUserDefaults standardUserDefaults] objectForKey:kSELECTED_APPLICATION];
        if(selectedApplicationData) {
            self.selectedApplication = [NSKeyedUnarchiver unarchiveObjectWithData:selectedApplicationData];
            NSLog(@"Found serialized Selected Application: %@", self.selectedApplication.displayName);
        }
    }
    return self;
}

+(BTNCache*)sharedCache {
    if(!sharedCache) {
        sharedCache = [[BTNCache alloc] init];
    }
    
    return sharedCache;
}

#pragma mark - Selected Application cache
-(void)setSelectedApplication:(BTNApplication *)theSelectedApplication {
    if(theSelectedApplication) {
        NSLog(@"Serializing Selected Application: %@", theSelectedApplication.displayName);
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        NSData* notificationsData=[NSKeyedArchiver archivedDataWithRootObject:theSelectedApplication];
        [defaults setObject: notificationsData forKey:kSELECTED_APPLICATION];
        [defaults synchronize];
    }
    selectedApplication = theSelectedApplication;
}
-(BTNApplication *)selectedApplication {
    return selectedApplication;
}

@end
