//
//  Job.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/23/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Job : NSObject <NSCoding>

@property (nonatomic, strong) NSString *jobNumber;
@property (nonatomic, strong) NSString *jobName;

@property (nonatomic, strong) NSMutableArray *tasksArray;

- (instancetype) initWithName:(NSString *)job;

- (void) addNewTaskWithName: (NSString *)name;

@end
