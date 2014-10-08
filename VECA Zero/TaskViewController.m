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

    NSLog(@"Task VC _job.jobIndexPath is: %lu", _job.jobIndexPath);
    

//    self.title = self.job.jobName;
    
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
//    _hazard = [self.task.hazardArray objectAtIndex:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    cell.detailTextLabel.text = [formatter stringFromDate:_task.date];
    
//    UILabel *hazardLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 7, 50, 30)];
//    [cell addSubview:hazardLabel];
//    
//    hazardLabel.text = [NSString stringWithFormat:@"%lu", [_task.hazardArray count]];
//    
//    
//    
//    
//    NSLog(@"Task VC - _task.hazardArray count is: %lu", [_task.hazardArray count]);
  
    [self configureTextForCell:cell
                   withJobName:_task];
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
//    }
    
//    Task *newTask = [self.job.tasksArray objectAtIndex:indexPath.row];
    
//    NSLog(@"%@", newTask.taskName);
    
//    cell.textLabel.text = newTask.taskName;
    
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
//    [self.tableView reloadData];
}

- (void)AddTaskViewController:(AddTaskViewController *)controller didFinishAddingItem:(Task *)task {
    NSInteger newRowIndex = [self.job.tasksForJobArray count];
    [self.job.tasksForJobArray addObject:task];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

    [self saveData];
    NSLog(@"Task Added");
}


-(void)AddTaskViewController:(AddTaskViewController *)controller didFinishEditingItem:(Task *)task {
  NSInteger newRowIndex = ([self.job.tasksForJobArray count] -1);

  [self.job.tasksForJobArray replaceObjectAtIndex:newRowIndex withObject:task];

  [self saveData];
  NSLog(@"Task Edited");
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
      
        
//        
//        NSLog(@"Task VC _task.taskIndex Path is: %lu", _task.taskIndexPath);
    }
}

@end
