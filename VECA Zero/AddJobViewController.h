//
//  AddJobViewController.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Job.h"

@class AddJobViewController;
@class Job;

@protocol AddJobViewControllerDelegate <NSObject>

- (void)AddJobViewControllerDidCancel:(AddJobViewController *)controller;

- (void)AddJobViewController:(AddJobViewController *)controller
             didFinishAddingItem:(Job *)job;

- (void)AddJobViewController:(AddJobViewController *)controller
            didFinishEditingItem:(Job *)job;

@end

@interface AddJobViewController : UIViewController

- (IBAction)Cancel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIColor *navBarColor;
@property (weak, nonatomic) IBOutlet UITextField *jobNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectNameTextField;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

//@property (strong, nonatomic) Job *selectedJob;
@property (strong, nonatomic) Job *jobToEdit;

@property (nonatomic, weak) id <AddJobViewControllerDelegate> delegate;

@end
