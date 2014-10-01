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
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fullName forKey:@"fullName"];
}

@end
