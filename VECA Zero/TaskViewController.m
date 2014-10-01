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
#import "JobsViewController.h"
#import "AddHazardsViewController.h"

@interface TaskViewController () <UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) NSMutableArray *taskArray;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addTaskBarButton;

@end

@implementation TaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.addTaskBarButton.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.title = self.job.jobName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    Task *task = self.job.tasksForJobArray[indexPath.row];
    
    [self configureTextForCell:cell withJobName:task];
    
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
}

- (void)AddTaskViewController:(AddTaskViewController *)controller didFinishAddingItem:(Task *)task {
    NSInteger newRowIndex = [self.job.tasksForJobArray count];
    [self.job.tasksForJobArray addObject:task];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self performSegueWithIdentifier:@"NewHazards" sender:task];
    NSLog(@"Task Added");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewTask"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddTaskViewController *controller = (AddTaskViewController *)navigationController.topViewController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"NewHazards"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddHazardsViewController *controller = (AddHazardsViewController *)navigationController.topViewController;
        controller.delegate = self;
    }
}

@end
