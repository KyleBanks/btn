//
//  BTNAppController.h
//  btn
//
//  Created by Kyle Banks on 2014-06-16.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTNApplicationItemView.h"
#import "BTNExecuteScriptView.h"

@interface BTNAppController : NSObject <BTNApplicationItemViewDelegate, BTNExecuteScriptViewProtocol>

@property (strong) IBOutlet NSMenu *statusMenu;

-(void)setBTNConnected:(BOOL)isConnected;

@end
