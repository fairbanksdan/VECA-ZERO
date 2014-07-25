//
//  Task.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/23/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Job.h"

@interface Task : NSObject

@property (nonatomic, strong) NSString *taskName;
@property (nonatomic, strong) NSDate *date;

@property (readwrite) Job *job;

- (instancetype) initWithName:(NSString *)taskName;

- (void) addTaskToJob:(Job *)job;

@end
