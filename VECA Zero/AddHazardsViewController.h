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

@class AddHazardsViewController;
@class Hazard;

@protocol AddHazardsViewControllerDelegate <NSObject>

- (void)AddHazardsViewControllerDidCancel:(AddHazardsViewController *)controller;

- (void)AddHazardsViewController:(AddHazardsViewController *)controller didFinishAddingItem:(Hazard *)hazard;

- (void)AddHazardsViewController:(AddHazardsViewController *)controller didFinishEditingItem:(Hazard *)hazard;

@end

@interface AddHazardsViewController : UIViewController

@property (strong, nonatomic) Task *task;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property NSMutableArray *localHazardsArray;

@property (nonatomic, weak) id <AddHazardsViewControllerDelegate> delegate;




@end
