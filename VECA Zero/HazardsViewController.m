//
//  AddHazardsViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "HazardsViewController.h"
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"HazardCell";
    HazardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    Hazard *hazard = [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:indexPath.row];
    cell.hazardLabel.text = hazard.hazardName;
    cell.solutionLabel.text = hazard.solution;
    
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == ([_localHazardsArray count]+ 1)) {
//        _string = @"1";
//        [_localHazardsArray addObject:_string];
//        
//        [tableView reloadData];
//    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self performSegueWithIdentifier:@"CheckIn" sender:self];
//    [self textFieldDidEndEditing:textField];
    return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [self performSegueWithIdentifier:@"CheckIn" sender:self];
//}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return UITableViewCellEditingStyleNone;
//    } else if (indexPath.section == ([_localHazardsArray count]+ 1)){
//        return UITableViewCellEditingStyleNone;
//    } else {
//        return UITableViewCellEditingStyleDelete;
//    }
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
//forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_localHazardsArray removeObjectAtIndex:indexPath.row];
//        [_textFields removeObjectAtIndex:indexPath.row];
//        [_solutionTextFields removeObjectAtIndex:indexPath.row];
//
//        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
//    }
//}

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
    }
}

-(void)SignInViewController:(SignInViewController *)controller didFinishSavingPersonArray:(NSMutableArray *)personsArray {
    _task.personArray = personsArray;
}

//-(void)saveHazard {
//    int i = 0;
//    while (i < ([_textFields count])) {
//        
//        _myTextField = [_textFields objectAtIndex:i];
//        _solutionTextField = [_solutionTextFields objectAtIndex:i];
//
//        Hazard *hazard = [Hazard new];
//        hazard.hazardName = _myTextField.text;
//        hazard.solution = _solutionTextField.text;
//        
//        [self.delegate HazardsViewController:self didFinishAddingItem:hazard];
//        
//        i += 1;
//    }
//    
//    [self.delegate HazardsViewController:self AndPersonsArray:_newPersonsArray];
//}

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



@end
