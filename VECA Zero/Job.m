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

- (instancetype) initWithName:(NSString *)job {
    if (self = [super init]) {
        self.jobName = job;
        self.tasksArray = [NSMutableArray new];
        
    }
    return self;
}

- (void) addNewTaskWithName: (NSString *)name {
    
    Task *task = [[Task alloc] initWithName:name];
    
    [task addTaskToJob:self];
}


@end
