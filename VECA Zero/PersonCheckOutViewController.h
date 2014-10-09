//
//  PersonCheckOutViewController.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 10/3/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureView.h"
#import "Person.h"
#import "Job.h"
#import "Task.h"

@interface PersonCheckOutViewController : UIViewController

@property (weak, nonatomic) IBOutlet SignatureView *checkOutSignature;
@property (strong, nonatomic) Job *job;
@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) Person *person;

@end
