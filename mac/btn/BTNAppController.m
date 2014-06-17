//
//  BTNAppController.m
//  btn
//
//  Created by Kyle Banks on 2014-06-16.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNAppController.h"
#import "NSImage+Additions.h"
#import "BTNApplication.h"
#import "BTNAppDelegate.h"

NSInteger const CONNSTATUS_DISCONNECTED = 0;
NSInteger const CONNSTATUS_CONNECTED = 1;
NSInteger const CONNSTATUS_CONNECTING = 2;

@implementation BTNAppController
{
    NSStatusItem *statusItem;
    
    int connectionStatus;
    NSDictionary *statusIconMap;
    
    NSArray *applicationList;
    NSMetadataQuery *applicationListQuery;
}

-(id)init {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    if(self = [super init]) {
        connectionStatus = CONNSTATUS_CONNECTING;
        
        statusIconMap = @{
            [NSNumber numberWithInt:CONNSTATUS_CONNECTED]: [[NSImage imageNamed:@"connstatus_connected"] scaledToHeight:19.0f],
            [NSNumber numberWithInt:CONNSTATUS_DISCONNECTED]: [[NSImage imageNamed:@"connstatus_disconnected"] scaledToHeight:19.0f],
            [NSNumber numberWithInt:CONNSTATUS_CONNECTING]: [[NSImage imageNamed:@"connstatus_connecting"] scaledToHeight:19.0f]
        };
        
        NSNib *nib = [[NSNib alloc] initWithNibNamed:@"MainMenu" bundle:[NSBundle mainBundle]];
        NSArray *topLevelObjects;
        if (![nib instantiateWithOwner:self topLevelObjects:&topLevelObjects]) {
            NSLog(@"ERROR: Unable to initialize BTNAppController");
        } else {
            NSLog(@"BTNAppController initialized.");
        }
        
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(updateStatusBarIcon)
                                       userInfo:nil
                                        repeats:YES];
        [self queryForInstalledApplications];
    }
    
    return self;
}

-(void)awakeFromNib {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:self.statusMenu];
    [statusItem setHighlightMode:YES];
   // menuView = [[BTNMenuView alloc] initWithStatusItem:statusItem];
    
}

-(void)setBTNConnected:(BOOL)isConnected {
    if(isConnected) {
        connectionStatus = CONNSTATUS_CONNECTED;
    } else {
        connectionStatus = CONNSTATUS_DISCONNECTED;
    }
}

-(void)updateStatusBarIcon {
    NSImage *image = [statusIconMap objectForKey:[NSNumber numberWithInt:connectionStatus]];
    [statusItem setImage:image];
}

# pragma mark - Get list of installed apps
-(void)queryForInstalledApplications {
    applicationListQuery = [[NSMetadataQuery alloc] init];
    [applicationListQuery setSearchScopes: @[@"/Applications"]];  // if you want to isolate to Applications
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"kMDItemKind == 'Application'"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(installedApplicationsQueryFinished:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification
                                               object:nil];
    
    [applicationListQuery setPredicate:pred];
    [applicationListQuery startQuery];
}
-(void)installedApplicationsQueryFinished:(NSNotification *)notification {
    NSMutableArray *tmpApplicationList = [[NSMutableArray alloc] init];
    for(NSMetadataItem *applicationMeta in applicationListQuery.results) {
        NSString *displayName = [applicationMeta valueForAttribute:(__bridge NSString *)kMDItemDisplayName];
        NSString *path = [applicationMeta valueForAttribute:(__bridge NSString *)kMDItemPath];
        NSImage *image = [[NSWorkspace sharedWorkspace] iconForFile:path];
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        
        if(displayName && path && image) {
            [tmpApplicationList addObject:[[BTNApplication alloc] initWithDisplayName:displayName
                                                                           andPath:[NSURL URLWithString:path]
                                                                          andImage:image]];
        }

    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayName"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    applicationList = [tmpApplicationList sortedArrayUsingDescriptors:sortDescriptors];
    NSLog(@"Found %lu applications...", (unsigned long)applicationList.count);
    
    int index = 0;
    for(BTNApplication *app in applicationList) {
        
        NSMenuItem *item = [[NSMenuItem alloc] init];
        NSArray *topLevelObjects;
        [[NSBundle mainBundle] loadNibNamed:@"ApplicationItemView"
                                      owner:nil
                            topLevelObjects:&topLevelObjects];
        for(id topLevelObject in topLevelObjects) {
            if([topLevelObject isKindOfClass:[BTNApplicationItemView class]]) {
                BTNApplicationItemView *applicationItemView = (BTNApplicationItemView *) topLevelObject;
                applicationItemView.delegate = self;
                applicationItemView.application = app;

                item.view = applicationItemView;
                [self.statusMenu addItem:item];
                break;
            }
        }

        index++;
    }
}

#pragma mark BTNApplicationItemViewDelegate
-(void)application:(BTNApplication *)application wasClicked:(NSEvent *)event {
    [self.statusMenu cancelTracking];
    
    self.appDelegate.selectedApplication = application;
    [self.appDelegate saveSelectedApplication];
}
-(BTNApplication *)selectedApplication {
    return self.appDelegate.selectedApplication;
}
@end
