//
//  BTNApplication.m
//  btn
//
//  Created by Kyle Banks on 2014-06-16.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNApplication.h"

NSString * const kDISPLAY_NAME = @"displayName";
NSString * const kPATH = @"path";
NSString * const kIMAGE = @"image";

@implementation BTNApplication

-(id)initWithDisplayName:(NSString *)displayName andPath:(NSURL *)path andImage:(NSImage *)image {
    if(self = [super init]) {
        self.displayName = displayName;
        self.path = path;
        self.image = image;
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.displayName forKey:kDISPLAY_NAME];
    [aCoder encodeObject:self.path.absoluteString forKey:kPATH];
    [aCoder encodeObject:self.image forKey:kIMAGE];
}
-(id) initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.displayName = [aDecoder decodeObjectForKey:kDISPLAY_NAME];
        self.path = [NSURL URLWithString:[aDecoder decodeObjectForKey:kPATH]];
        self.image = [aDecoder decodeObjectForKey:kIMAGE];
    }
    
    return self;
}

-(BOOL)isEqual:(id)object {
    if([object isKindOfClass:[BTNApplication class]]) {
        BTNApplication *other = (BTNApplication *)object;
        
        if([other.path.absoluteString isEqualToString:self.path.absoluteString]) {
            return YES;
        }
    }
    
    return NO;
}

@end
