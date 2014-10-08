//
//  Task.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/23/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "Task.h"

@implementation Task

- (id)init {
    if ((self = [super init])) {
        self.hazardArray = [[NSMutableArray alloc] initWithCapacity:20];
        self.personArray = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return self;
}

- (instancetype) initWithName:(NSString *)taskName {
    if (self = [super init]) {        
        self.taskName = taskName;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.taskName = [aDecoder decodeObjectForKey:@"taskName"];
        self.date = [aDecoder decodeObjectForKey:@"Date"];
        self.hazardArray = [aDecoder decodeObjectForKey:@"hazardArray"];
        self.personArray = [aDecoder decodeObjectForKey:@"personArray"];
        self.specificTaskLocation = [aDecoder decodeObjectForKey:@"specificTaskLocation"];
        self.PrimaryEvacuation = [aDecoder decodeObjectForKey:@"PrimaryEvacuation"];
        self.SecondaryEvacuation = [aDecoder decodeObjectForKey:@"SecondaryEvacuation"];
        self.taskIndexPath = [aDecoder decodeIntegerForKey:@"taskIndexPath"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.taskName forKey:@"taskName"];
    [aCoder encodeObject:self.date forKey:@"Date"];
    [aCoder encodeObject:self.hazardArray forKey:@"hazardArray"];
    [aCoder encodeObject:self.personArray forKey:@"personArray"];
    [aCoder encodeObject:self.specificTaskLocation forKey:@"specificTaskLocation"];
    [aCoder encodeObject:self.PrimaryEvacuation forKey:@"PrimaryEvacuation"];
    [aCoder encodeObject:self.SecondaryEvacuation forKey:@"SecondaryEvacuation"];
    [aCoder encodeInteger:self.taskIndexPath forKey:@"taskIndexPath"];
}




@end
