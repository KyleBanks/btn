//
//  BTNAppController.h
//  btn
//
//  Created by Kyle Banks on 2014-06-16.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTNApplicationItemView.h"

@class BTNAppDelegate;

@interface BTNAppController : NSObject <BTNApplicationItemViewDelegate>

@property (strong) IBOutlet NSMenu *statusMenu;

@property BTNAppDelegate *appDelegate;

-(void)setBTNConnected:(BOOL)isConnected;

@end
