//
//  TaskViewController.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/23/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Job.h"
#import "Task.h"

@interface TaskViewController : UIViewController

@property (strong, nonatomic) Job *job;
@property (strong, nonatomic) NSString *tasks;
@property (readwrite) Task *task;

@end
