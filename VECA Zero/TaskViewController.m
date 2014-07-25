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
#import "HistoryViewController.h"

@interface TaskViewController () <UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) NSMutableArray *taskArray;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)self.job.tasksArray.count);
    return self.job.tasksArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"TaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    Task *newTask = [self.job.tasksArray objectAtIndex:indexPath.row];
    
    NSLog(@"%@", newTask.taskName);
    
    cell.textLabel.text = newTask.taskName;
    
    return cell;
    
}

@end
