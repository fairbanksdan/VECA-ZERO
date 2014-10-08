//
//  Task.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/23/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Job.h"

@interface Task : NSObject <NSCoding>

@property (nonatomic, strong) NSString *taskName;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *specificTaskLocation;
@property (nonatomic, strong) NSString *PrimaryEvacuation;
@property (nonatomic, strong) NSString *SecondaryEvacuation;

@property (nonatomic, strong) NSMutableArray *hazardArray;
@property (nonatomic, strong) NSMutableArray *personArray;

@property NSInteger taskIndexPath;

//@property (readwrite) Job *job;

//- (instancetype) initWithName:(NSString *)taskName;
//
//- (void) addTaskToJob:(Job *)job;

@end
