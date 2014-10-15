//
//  SignOutViewController.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "Job.h"
#import "Task.h"
#import "Hazard.h"
#import "PersonCheckOutViewController.h"

@interface SignOutViewController : UIViewController <PersonCheckOutViewControllerDelegate>

@property (strong, nonatomic) Job *job;
@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) Person *person;

@end
