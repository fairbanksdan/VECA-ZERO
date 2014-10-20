//
//  TaskViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/23/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "TaskViewController.h"
#import "Task.h"
#import "Job.h"
#import "Hazard.h"
#import "JobsViewController.h"
#import "AddHazardsViewController.h"
#import "DataModel.h"
#import "SignInViewController.h"

@interface TaskViewController () <UITableViewDataSource, UITableViewDelegate>
{
    DataModel *_dataModel;
}

//@property (nonatomic, strong) NSMutableArray *taskArray;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addTaskBarButton;

@end

@implementation TaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addTaskBarButton.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveData
{
    [DataModel.myDataModel saveJobs];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.job.tasksForJobArray count];
}

- (void)configureTextForCell:(UITableViewCell *)cell
                 withJobName:(Task *)task
{
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
  
    label.text = task.taskName;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"TaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    _task = self.job.tasksForJobArray[indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    cell.detailTextLabel.text = [formatter stringFromDate:_task.date];
  
    [self configureTextForCell:cell
                   withJobName:_task];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.job.tasksForJobArray removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)AddTaskViewControllerDidCancel:(AddTaskViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddTaskViewController:(AddTaskViewController *)controller didFinishAddingItem:(Task *)task {
    NSInteger newRowIndex = [self.job.tasksForJobArray count];
    [self.job.tasksForJobArray insertObject:task atIndex:0];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

    [self saveData];
}


-(void)AddTaskViewController:(AddTaskViewController *)controller didFinishEditingItem:(Task *)task {
  NSInteger newRowIndex = ([self.job.tasksForJobArray count] -1);

  [self.job.tasksForJobArray replaceObjectAtIndex:newRowIndex withObject:task];

  [self saveData];
  [self.tableView reloadData];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewTask"]) {
        
        NSInteger myIndexPath = (long)[_job.tasksForJobArray count];
        
        Task *myTask = [Task new];
        
        UINavigationController *navigationController = segue.destinationViewController;
        AddTaskViewController *controller = (AddTaskViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.job = _job;
        controller.task = myTask;
        controller.task.taskIndexPath = myIndexPath;
    }
}

@end
