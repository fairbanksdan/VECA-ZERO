//
//  Hazard.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/23/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "Hazard.h"

@implementation Hazard

- (void)toggleChecked
{
    self.checked = !self.checked;
}

- (instancetype) initWithName:(NSString *)hazardName {
    if (self = [super init]) {
        self.hazardName = hazardName;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.hazardName = [aDecoder decodeObjectForKey:@"hazardName"];
        self.solution = [aDecoder decodeObjectForKey:@"solution"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.hazardName forKey:@"hazardName"];
    [aCoder encodeObject:self.solution forKey:@"solution"];
}

@end
