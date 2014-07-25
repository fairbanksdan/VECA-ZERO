//
//  Task.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/23/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "Task.h"

@implementation Task

- (instancetype) initWithName:(NSString *)taskName {
    if (self = [super init]) {
        self.taskName = taskName;
    }
    return self;
}

- (void) addTaskToJob:(Job *)job {
    [job.tasksArray addObject:self];
    self.job = job;
}


@end
