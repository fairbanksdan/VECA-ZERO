//
//  ViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/18/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "HistoryViewController.h"
#import "TaskViewController.h"
#import "Task.h"
#import "Job.h"

@interface HistoryViewController  () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *jobArray;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddJobBarButton;

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBarColor = [[UIColor alloc] initWithRed:.027344 green:.445313 blue:.898438 alpha:1];
    
    self.jobArray = [[NSMutableArray alloc] init];
    
    Job *job1 = [[Job alloc] initWithName:@"Olive 8"];
//    job1.jobNumber = @"184902";
//    job1.jobName = @"Olive 8";
    
    Job *job2 = [[Job alloc] initWithName:@"Broadway Subway"];
//    job2.jobNumber = @"184903";
//    job2.jobName = @"Broadway Subway";
    
//    [self.jobArray addObject:job1];
//    [self.jobArray addObject:job2];
    
    Task *task1 = [Task new];
    task1.taskName = @"Install J-Hooks";
    
    Task *task2 = [Task new];
    task2.taskName = @"Pull Cable";
    
    [job1.tasksArray addObject:task1];
    [job2.tasksArray addObject:task2];
    
//    [job1 addNewTaskWithName:task1.taskName];
    
    self.jobArray = [NSMutableArray arrayWithObjects:job1, job2, nil];
    
    self.navigationController.navigationBar.barTintColor = self.navBarColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.AddJobBarButton.tintColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jobArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"JobCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        
    }
    
    Job *newJob = [self.jobArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:.3];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = newJob.jobName;
    
    
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showTaskDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TaskViewController *destViewController = segue.destinationViewController;
        Job *job = [self.jobArray objectAtIndex:indexPath.row];
        destViewController.tasks = job.jobName;
        destViewController.title = destViewController.tasks;
        destViewController.job = job;
    }
}

@end
