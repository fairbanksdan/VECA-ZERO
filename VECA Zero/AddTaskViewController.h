//
//  AddTaskViewController.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 9/30/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HazardsViewController.h"

@class AddTaskViewController;
@class Task;

@protocol AddTaskViewControllerDelegate <NSObject>

- (void)AddTaskViewControllerDidCancel:(AddTaskViewController *)controller;

- (void)AddTaskViewController:(AddTaskViewController *)controller didFinishAddingItem:(Task *)task;

@optional

- (void)AddTaskViewController:(AddTaskViewController *)controller didFinishEditingItem:(Task *)task;

@end

@interface AddTaskViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIColor *navBarColor;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButton;
@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *specificTaskLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *PrimaryEvacTextField;
@property (weak, nonatomic) IBOutlet UITextField *SecondaryEvacTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, weak) id <AddTaskViewControllerDelegate> delegate;

@property (nonatomic, strong) Job *job;
@property (nonatomic, strong) Task *task;

- (IBAction)cancel;

@end
