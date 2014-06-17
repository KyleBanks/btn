//
//  BTNApplicationItemView.h
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BTNApplication;

@protocol BTNApplicationItemViewDelegate <NSObject>
-(void)application:(BTNApplication *)application wasClicked:(NSEvent *)event;
-(BTNApplication *)selectedApplication;
@end


@interface BTNApplicationItemView : NSView

@property BTNApplication *application;

@property (weak) IBOutlet NSTextField *txtDisplayName;
@property (weak) IBOutlet NSImageView *imgImage;
@property (weak) IBOutlet NSImageView *imgSelected;

@property id<BTNApplicationItemViewDelegate> delegate;

@end
