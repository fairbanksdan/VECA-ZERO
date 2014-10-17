//
//  HazardsViewController.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "HazardTableViewCell.h"
#import "SignInViewController.h"
#import "Person.h"
#import "AddHazardViewController.h"

@class HazardsViewController;
@class Hazard;

//@protocol HazardsViewControllerDelegate <NSObject>
//
//- (void)HazardsViewController:(HazardsViewController *)controller didFinishAddingItem:(Hazard *)hazard;
//
//- (void)HazardsViewController:(HazardsViewController *)controller AndPersonsArray:(NSMutableArray *)myPersonArray;
//
//@optional
//
//- (void)HazardsViewControllerDidCancel:(HazardsViewController *)controller;
//
//- (void)HazardsViewController:(HazardsViewController *)controller didFinishEditingItem:(Hazard *)hazard;
//
//@end

@interface HazardsViewController : UIViewController <SignInViewControllerDelegate, AddHazardViewControllerDelegate>

@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) Job *job;
@property (strong, nonatomic) Hazard *hazard;
@property UITextField *myTextField;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

//@property (nonatomic, weak) id <HazardsViewControllerDelegate> delegate;


@end
