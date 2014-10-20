//
//  Job.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/23/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "Job.h"
#import "Task.h"

@implementation Job

- (id)init {
    if ((self = [super init])) {
        self.tasksForJobArray = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.jobName = [aDecoder decodeObjectForKey:@"jobName"];
        self.jobNumber = [aDecoder decodeObjectForKey:@"jobNumber"];
        self.tasksForJobArray = [aDecoder decodeObjectForKey:@"tasksForJobArray"];
        self.jobIndexPath = [aDecoder decodeIntegerForKey:@"jobIndexPath"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.jobName forKey:@"jobName"];
    [aCoder encodeObject:self.jobNumber forKey:@"jobNumber"];
    [aCoder encodeObject:self.tasksForJobArray forKey:@"tasksForJobArray"];
    [aCoder encodeInteger:self.jobIndexPath forKey:@"jobIndexPath"];
}

@end
