//
//  SignInViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "SignInViewController.h"
#import "Person.h"
#import "MidTaskViewController.h"
#import "NSMutableArray+SWUtilityButtons.h"
#import "SWTableViewCell.h"
#import "PersonTableViewCell.h"
#import "Task.h"
#import "Hazard.h"
#import "DataModel.h"
#import "Job.h"

@interface SignInViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveTaskButton;
@property (weak, nonatomic) IBOutlet UIButton *addPersonButton;


@end

@implementation SignInViewController
{
    NSMutableArray *_persons;
    Job *_job;
    Task *_task;
    Hazard *_hazard;
    NSMutableArray *_newHazardsArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.saveTaskButton.layer setCornerRadius:5];
    [self.addPersonButton.layer setCornerRadius:5];
    
    _persons = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray];
    
    if (_persons.count < 1) {
        Person *mainUser = DataModel.myDataModel.mainUser;
        [_persons addObject:mainUser];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    if (_persons.count == 0) {
        self.saveTaskButton.enabled = NO;
    } else if (_persons.count > 0) {
        self.saveTaskButton.enabled = YES;
    }
}

- (void)configureTextForCell:(UITableViewCell *)cell withPersonName:(Person *)person {
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = person.fullName;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_persons count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Person *person = _persons[indexPath.row];
    [self performSegueWithIdentifier:@"EditPerson" sender:person];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"PersonCell";
    PersonTableViewCell *cell = (PersonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    Person *person = _persons[indexPath.row];
    [self configureTextForCell:cell withPersonName:person];
    
    return cell;
}

- (void)AddPersonViewController:(AddPersonViewController *)controller didFinishAddingItem:(Person *)person {
    NSInteger newRowIndex = [_persons count];
    [_persons addObject:person];
    NSIndexPath *indexPath = [NSIndexPath
                              indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
//    [self savePersons];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddPersonViewController:(AddPersonViewController *)controller didFinishEditingItem:(Person *)person {
    NSInteger index = [_persons indexOfObject:person];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                inSection:0];
    UITableViewCell *cell = [self.tableView
                             cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withPersonName:person];
    
//    [self savePersons];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddPersonViewControllerDidCancel:(AddPersonViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"AddPerson"]) {
        UINavigationController *navigationController =
        segue.destinationViewController;
        AddPersonViewController *controller = (AddPersonViewController *)navigationController;
        controller.delegate = self;
        controller.personToEdit = nil;
        controller.job = _job;
        controller.task = _task;
        controller.task.hazardArray = _task.hazardArray;
    } else if ([segue.identifier isEqualToString:@"EditPerson"]) {
        UINavigationController *navigationController =
        segue.destinationViewController;
        AddPersonViewController *controller = (AddPersonViewController *)navigationController;
        
        NSIndexPath *indexPath = [self.tableView
                                  indexPathForSelectedRow];
        if (sender == self) {
            controller.personToEdit = _persons[indexPath.row];
        } else {
        controller.personToEdit = sender;
        }
        controller.job = _job;
        controller.task = _task;
        controller.task.hazardArray = _task.hazardArray;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"MidTask"]) {
        MidTaskViewController *destViewController = segue.destinationViewController;
        destViewController.job = _job;
        destViewController.task = _task;
        destViewController.task.personArray = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray];
   
    }
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
    
    PersonTableViewCell *cell;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            Person *person = [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:cellIndexPath.row];
            
            [self performSegueWithIdentifier:@"EditPerson" sender:person];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] removeObjectAtIndex:cellIndexPath.row];
            
            NSArray *indexPaths = @[cellIndexPath];
            [self.tableView deleteRowsAtIndexPaths:indexPaths
                                  withRowAnimation:UITableViewRowAnimationLeft];
            
            if (_persons.count == 0) {
                self.saveTaskButton.enabled = NO;
            } else if (_persons.count > 0) {
                self.saveTaskButton.enabled = YES;
            }
            break;
        }
        default:
            break;
    }
}

-(void) segueToAddPersonVC{
    [self performSegueWithIdentifier:@"EditPerson" sender:self];
}

- (IBAction)saveAllTaskData:(UIButton *)sender {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveAllTaskData" object:nil];
}

- (IBAction)addPersonButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"AddPerson" sender:self];
}


@end
