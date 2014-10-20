//
//  AddHazardsViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "HazardsViewController.h"
#import "NSMutableArray+SWUtilityButtons.h"
#import "SWTableViewCell.h"
#import "Hazard.h"
#import "Job.h"
#import "Task.h"
#import "HazardTableViewCell.h"
#import "SignInViewController.h"
#import "DataModel.h"

@interface HazardsViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addHazard;

@end

@implementation HazardsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.addHazard.layer setCornerRadius:5];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if ([[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] count] == 0) {
        self.nextButton.enabled = NO;
    } else {
        self.nextButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 154;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Complete this page at task location";
    } else {
        return @"";
    }
}

-(void)configureTextForCell:(HazardTableViewCell *)cell withHazard:(Hazard *)hazard {
    cell.hazardLabel.text = hazard.hazardName;
    cell.solutionLabel.text = hazard.solution;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"HazardCell";
    HazardTableViewCell *cell = (HazardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    Hazard *hazard = [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:indexPath.row];
//    cell.hazardLabel.text = hazard.hazardName;
//    cell.solutionLabel.text = hazard.solution;
    
    [self configureTextForCell:cell withHazard:hazard];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self performSegueWithIdentifier:@"CheckIn" sender:self];
//    [self textFieldDidEndEditing:textField];
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"CheckIn"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveAllTaskData" object:nil];
            UINavigationController *navigationController = segue.destinationViewController;
            SignInViewController *controller = (SignInViewController *)navigationController;
            controller.delegate = self;
            
            controller.job = _job;
            controller.task = _task;
            controller.task.hazardArray = _task.hazardArray;
    } else if ([segue.identifier isEqualToString:@"AddHazard"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddHazardViewController *controller = (AddHazardViewController *)navigationController.topViewController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"EditHazard"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddHazardViewController *controller = (AddHazardViewController *)navigationController.topViewController;
        NSIndexPath *indexPath = [self.tableView
                                  indexPathForCell:sender];
        Hazard *sendingHazard = [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex: indexPath.row];
        sendingHazard = sender;
        if (sender == nil) {
            controller.hazardToEdit = [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex: indexPath.row];
        } else {
            controller.hazardToEdit = sender;
        }
        
        controller.delegate = self;
    }
}

-(void)SignInViewController:(SignInViewController *)controller didFinishSavingPersonArray:(NSMutableArray *)personsArray {
    _task.personArray = personsArray;
}

- (void)AddHazardViewControllerDidCancel:(AddHazardViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddHazardViewController:(AddHazardViewController *)controller didFinishAddingHazard:(Hazard *)hazard {
    NSInteger newRowIndex = [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] count];
    [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] addObject:hazard];
    NSIndexPath *indexPath = [NSIndexPath
                              indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    self.nextButton.enabled = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddHazardViewController:(AddHazardViewController *)controller didFinishEditingHazard:(Hazard *)hazard {
    NSInteger index = [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] indexOfObject:hazard];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                inSection:0];
    HazardTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self configureTextForCell:cell withHazard:hazard];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    HazardTableViewCell *cell;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            Hazard *hazard = [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:cellIndexPath.row];
            [self performSegueWithIdentifier:@"EditHazard" sender:hazard];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] removeObjectAtIndex:cellIndexPath.row];
            
            NSArray *indexPaths = @[cellIndexPath];
            [self.tableView deleteRowsAtIndexPaths:indexPaths
                                  withRowAnimation:UITableViewRowAnimationLeft];
            
//            [self saveData];
            break;
        }
        default:
            break;
    }
}


@end
