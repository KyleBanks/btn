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
#import "BTNCache.h"
#import "BTNMenuItemView.h"
#import "BTNOpenURLView.h"

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

#pragma mark - Initialization
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
    }
    
    return self;
}

-(void)awakeFromNib {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:self.statusMenu];
    [statusItem setHighlightMode:YES];
    
    [self constructMenu];
}

#pragma mark - Connection Status Management
-(void)setBTNConnected:(BOOL)isConnected {
    if(isConnected) {
        connectionStatus = CONNSTATUS_CONNECTED;
    } else {
        connectionStatus = CONNSTATUS_DISCONNECTED;
    }
}

#pragma mark - Menu Management
-(void)updateStatusBarIcon {
    NSImage *image = [statusIconMap objectForKey:[NSNumber numberWithInt:connectionStatus]];
    [statusItem setImage:image];
}

-(void)constructMenu {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    [self.statusMenu removeAllItems];
    
    NSMenuItem *itemApplicationList = [[NSMenuItem alloc] init];
    [itemApplicationList setView:[self constructMenuItemViewForAction:BTNActionOpenApplication]];
    [self.statusMenu addItem:itemApplicationList];
    
    if(applicationList) {
        [self constructApplicationList:itemApplicationList];
    } else {
        [self queryForInstalledApplications];
    }
    
    NSMenuItem *itemOpenURL = [[NSMenuItem alloc] init];
    [itemOpenURL setView:[self constructMenuItemViewForAction:BTNActionOpenURL]];
    itemOpenURL.submenu = [self constructOpenURLSubmenu];
    [self.statusMenu addItem:itemOpenURL];
    
    NSMenuItem *itemExecuteScript = [[NSMenuItem alloc] init];
    [itemExecuteScript setView:[self constructMenuItemViewForAction:BTNActionExecuteScript]];
    itemExecuteScript.submenu = [self constructExecuteScriptSubmenu];
    [self.statusMenu addItem:itemExecuteScript];
    
}

-(BTNMenuItemView *)constructMenuItemViewForAction:(BTNAction)action {
    BTNMenuItemView *view = nil;
    
    NSArray *topLevelObjects;
    [[NSBundle mainBundle] loadNibNamed:@"MenuItemView"
                                  owner:nil
                        topLevelObjects:&topLevelObjects];
    
    for(id topLevelObject in topLevelObjects) {
        if([topLevelObject isKindOfClass:[BTNMenuItemView class]]) {
            view = (BTNMenuItemView *) topLevelObject;
            view.representingAction = action;
            break;
        }
    }
    return view;
}

-(void)constructApplicationList:(NSMenuItem *)itemApplicationList {
    NSMenu *submenu = [[NSMenu alloc] init];

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
                
                [submenu addItem:item];
                break;
            }
        }
    }
    
    [itemApplicationList setSubmenu:submenu];
}
-(NSMenu *)constructOpenURLSubmenu {
    NSMenu *subMenu = [[NSMenu alloc] init];
    
    BTNOpenURLView *view = nil;
    NSArray *topLevelObjects;
    [[NSBundle mainBundle] loadNibNamed:@"OpenURLView"
                                  owner:nil
                        topLevelObjects:&topLevelObjects];
    
    for(id topLevelObject in topLevelObjects) {
        if([topLevelObject isKindOfClass:[BTNOpenURLView class]]) {
            view = (BTNOpenURLView *) topLevelObject;
            break;
        }
    }
    
    
    NSMenuItem *openURLItem = [[NSMenuItem alloc] init];
    [openURLItem setView:view];
    [subMenu addItem:openURLItem];
    
    return subMenu;
    
}
-(NSMenu *)constructExecuteScriptSubmenu {
    NSMenu *submenu = [[NSMenu alloc] init];
    
    BTNExecuteScriptView *view = nil;
    NSArray *topLevelObjects;
    [[NSBundle mainBundle] loadNibNamed:@"ExecuteScriptView"
                                  owner:nil
                        topLevelObjects:&topLevelObjects];
    
    for(id topLevelObject in topLevelObjects) {
        if([topLevelObject isKindOfClass:[BTNExecuteScriptView class]]) {
            view = (BTNExecuteScriptView *) topLevelObject;
            view.delegate = self;
            break;
        }
    }
    
    NSMenuItem *executeScriptItem = [[NSMenuItem alloc] init];
    [executeScriptItem setView:view];
    [submenu addItem:executeScriptItem];
    
    return submenu;
}

# pragma mark - Get list of installed apps
-(void)queryForInstalledApplications {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));

    applicationListQuery = [[NSMetadataQuery alloc] init];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"kMDItemKind == 'Application'"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(installedApplicationsQueryFinished:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification
                                               object:nil];
    
    [applicationListQuery setPredicate:pred];
    [applicationListQuery setSearchScopes: @[@"/Applications"]];
    [applicationListQuery startQuery];
}
-(void)installedApplicationsQueryFinished:(NSNotification *)notification {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:nil];

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
    
    [self constructMenu];
}

#pragma mark - BTNApplicationItemViewDelegate
-(void)application:(BTNApplication *)application wasClicked:(NSEvent *)event {
    [self.statusMenu cancelTracking];
    
    [BTNCache sharedCache].selectedApplication = application;
    [BTNCache sharedCache].preferredAction = BTNActionOpenApplication;
}
-(BTNApplication *)selectedApplication {
    return [BTNCache sharedCache].selectedApplication;
}
#pragma mark - BTNExecuteScriptViewDelegate
-(void)btnExecuteScriptView:(BTNExecuteScriptView *)executeScriptView didSelectScript:(BTNScript *)script {
    [self.statusMenu cancelTracking];
    
    [BTNCache sharedCache].selectedScript = script;
    [BTNCache sharedCache].preferredAction = BTNActionExecuteScript;
}
@end
