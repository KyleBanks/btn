//
//  BTNAction.h
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BTNAction) {
    BTNActionDoNothing, //Must be kept first to equal 0
    BTNActionOpenApplication,
    BTNActionOpenURL,
    BTNActionExecuteScript
};