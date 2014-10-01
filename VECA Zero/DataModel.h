//
//  DataModel.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 9/29/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableArray *tasksForJobs;

- (void)saveJobs;

@end
