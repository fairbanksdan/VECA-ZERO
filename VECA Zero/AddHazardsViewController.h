//
//  AddHazardsViewController.h
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

@class AddHazardsViewController;
@class Hazard;

@protocol AddHazardsViewControllerDelegate <NSObject>



- (void)AddHazardsViewController:(AddHazardsViewController *)controller didFinishAddingItem:(Hazard *)hazard;

- (void)AddHazardsViewController:(AddHazardsViewController *)controller AndPersonsArray:(NSMutableArray *)myPersonArray;



@optional

- (void)AddHazardsViewControllerDidCancel:(AddHazardsViewController *)controller;

- (void)AddHazardsViewController:(AddHazardsViewController *)controller didFinishEditingItem:(Hazard *)hazard;


@end


@interface AddHazardsViewController : UITableViewController <SignInViewControllerDelegate>

@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) Job *job;
@property UITextField *myTextField;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@property (nonatomic, weak) id <AddHazardsViewControllerDelegate> delegate;




@end
