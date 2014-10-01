//
//  NewTaskViewController.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewTaskViewController;
@class Task;

@protocol NewTaskViewControllerDelegate <NSObject>

- (void)NewTaskViewControllerDidCancel:(NewTaskViewController *)controller;

- (void)NewTaskViewController:(NewTaskViewController *)controller didFinishAddingItem:(Task *)task;

- (void)NewTaskViewController:(NewTaskViewController *)controller didFinishEditingItem:(Task *)task;

@end

@interface NewTaskViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIColor *navBarColor;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButton;

@property (nonatomic, weak) id <NewTaskViewControllerDelegate> delegate;

- (IBAction)cancel;
- (IBAction)next;

@end
