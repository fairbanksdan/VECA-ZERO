//
//  Person.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/23/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.fullName = [aDecoder decodeObjectForKey:@"fullName"];
        self.checkInSignature = [aDecoder decodeObjectForKey:@"checkInSignature"];
        self.isInjured = [aDecoder decodeBoolForKey:@"injured"];
        self.supervisor = [aDecoder decodeObjectForKey:@"supervisor"];
        self.checkOutSignature = [aDecoder decodeObjectForKey:@"checkOutSignature"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fullName forKey:@"fullName"];
    [aCoder encodeObject:self.checkInSignature forKey:@"checkInSignature"];
    [aCoder encodeBool:self.isInjured forKey:@"injured"];
    [aCoder encodeObject:self.supervisor forKey:@"supervisor"];
    [aCoder encodeObject:self.checkOutSignature forKey:@"checkOutSignature"];
    
}

@end
