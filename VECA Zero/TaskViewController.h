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
#import "Hazard.h"
#import "AddTaskViewController.h"
#import "AddHazardsViewController.h"

@interface TaskViewController : UIViewController <AddTaskViewControllerDelegate>

@property (strong, nonatomic) Job *job;
@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) Hazard *hazard;
//@property (strong, nonatomic) NSString *tasks;
//@property (readwrite) Task *task;


@end
