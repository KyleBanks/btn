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
            return @"Open Application";
        case BTNActionOpenURL:
            return @"Open URL(s)";
        case BTNActionExecuteScript:
            return @"Execute Script";
        case BTNActionDoNothing:
            return @"Do Nothing";
    }
    return nil;
}

@end