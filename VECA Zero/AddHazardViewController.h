//
//  AddHazardViewController.h
//  VECA Zero
//
//  Created by Dan Fairbanks on 10/16/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "HazardTableViewCell.h"
#import "SignInViewController.h"
#import "Person.h"

@class AddHazardViewController;
@class Hazard;

@protocol AddHazardViewControllerDelegate <NSObject>

- (void)AddHazardViewControllerDidCancel:(AddHazardViewController *)controller;

- (void)AddHazardViewController:(AddHazardViewController *)controller didFinishAddingHazard:(Hazard *)hazard;

- (void)AddHazardViewController:(AddHazardViewController *)controller didFinishEditingHazard:(Hazard *)hazard;

@end

@interface AddHazardViewController : UIViewController

- (IBAction)cancel;

@property (strong, nonatomic) Hazard *hazardToEdit;

@property (strong, nonatomic) Job *job;
@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) Hazard *hazard;

@property (nonatomic, weak) id <AddHazardViewControllerDelegate> delegate;

@end
