//
//  BTNScript.m
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNScript.h"

NSString * const kSCRIPT_PATH = @"path";
NSString * const kSHOW_OUTPUT = @"show-output";

@implementation BTNScript

#pragma mark - Initialization and Encoding
-(id) initWithPath:(NSURL *)path {
    if(self = [super init]) {
        self.path = path;
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.path = [aDecoder decodeObjectForKey:kSCRIPT_PATH];
        self.showOutput = [aDecoder decodeBoolForKey:kSHOW_OUTPUT];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.path forKey:kSCRIPT_PATH];
    [aCoder encodeBool:self.showOutput forKey:kSHOW_OUTPUT];
}

#pragma mark - Implementation
-(NSString *)executeWithError:(NSError **)err {
    NSLog(@"Execing script: %@", self.path.path);
    NSPipe* pipe = [NSPipe pipe];
    
    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/sh"];
    NSString *scriptContents = [[NSString alloc] initWithContentsOfFile:self.path.path
                                                               encoding:NSUTF8StringEncoding
                                                                  error:err];
    if(*err) {
        return nil;
    }
    [task setArguments:@[@"-c", scriptContents]];
    
    [task setStandardOutput:pipe];
    
    NSFileHandle* file = [pipe fileHandleForReading];
    [task launch];
    
    return [[NSString alloc] initWithData:[file readDataToEndOfFile]
                                 encoding:NSUTF8StringEncoding];
}
@end
