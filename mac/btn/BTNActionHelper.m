//
//  BTNActionHelper.m
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNActionHelper.h"

@implementation BTNActionHelper

+(NSString *)titleForBTNAction:(BTNAction)action {
    switch (action) {
        case BTNActionOpenApplication:
            return @"Open Applications";
        case BTNActionOpenURL:
            return @"Open URLs";
        case BTNActionExecuteScript:
            return @"Execute Script";
        case BTNActionSettings:
            return @"Settings";
        case BTNActionDoNothing:
            return @"Do Nothing";
    }
    return nil;
}

@end