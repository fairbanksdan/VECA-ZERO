//
//  DataController.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 8/6/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *jobArray, *taskArray, *hazardArray;

-(instancetype)initWithJobs;

+(DataController *)sharedData;

-(void)save;

@end
