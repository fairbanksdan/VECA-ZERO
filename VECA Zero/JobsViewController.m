//
//  ViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/18/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "JobsViewController.h"
#import "AddJobViewController.h"
#import "TaskViewController.h"
#import "DataController.h"
#import "Task.h"
#import "Job.h"
#import "NSMutableArray+SWUtilityButtons.h"
#import "SWTableViewCell.h"
#import "JobTableViewCell.h"
#import "DataModel.h"
#import "AppDelegate.h"

@interface JobsViewController  () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddJobBarButton;

@end

@implementation JobsViewController
{
    NSMutableArray *_lists; //creates a mutable Array with the variable "_items"
    DataModel *_sharedDataModel;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navBarColor = [[UIColor alloc] initWithRed:.027344 green:.445313 blue:.898438 alpha:1];
    
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

- (void)saveData
{
    [DataModel.myDataModel saveJobs];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    self.navigationController.delegate = self;
//    NSInteger index = [self.dataModel indexOfSelectedJob];
//    if (index >= 0 && index < [self.dataModel.tasksForJobs count]) {
//        Job *job = self.dataModel.tasksForJobs[index];
//        [self performSegueWithIdentifier:@"EditJob"
//                                  sender:job];
//    }
//}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)configureTextForCell:(UITableViewCell *)cell
           withJobName:(Job *)job
{
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = job.jobName;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return  [DataModel.myDataModel.jobsArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Job *job = DataModel.myDataModel.jobsArray[indexPath.row];
    [self performSegueWithIdentifier:@"Task" sender:job];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"JobCell";
    
    JobTableViewCell *cell = (JobTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    

        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
    
//    if (cell.rightUtilityButtons) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }

    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobCell"];
    
    Job *job = DataModel.myDataModel.jobsArray[indexPath.row];
    [self configureTextForCell:cell withJobName:job];
    
    return cell; //returns what is in each "cell" as defined in this method
}

- (void)AddJobViewController:(AddJobViewController *)controller
         didFinishAddingItem:(Job *)job; {
    NSInteger newRowIndex = [DataModel.myDataModel.jobsArray count];
    [DataModel.myDataModel.jobsArray insertObject:job atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath
                              indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [self saveData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddJobViewController:(AddJobViewController *)controller didFinishEditingItem:(Job *)job {
    NSInteger index = [DataModel.myDataModel.jobsArray indexOfObject:job];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                inSection:0];
    UITableViewCell *cell = [self.tableView
                             cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withJobName:job];
    
    [self saveData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddJobViewControllerDidCancel:(AddJobViewController *)controller; {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];

    Job *myJob;
    
    if ([segue.identifier isEqualToString:@"AddJob"]) {
//        AddJobViewController *addJobVC = segue.destinationViewController;
//        myJob = [Job new];
//        [[[DataController sharedData] jobArray] insertObject:myJob atIndex:0];
//        addJobVC.selectedJob = myJob;
        // 1
        UINavigationController *navigationController =
        segue.destinationViewController;
        // 2
        AddJobViewController *controller =
        (AddJobViewController *)
        navigationController;
        // 3
        controller.delegate = self;
        controller.jobToEdit = nil;
    } else if ([segue.identifier isEqualToString:@"EditJob"])
    {
        UINavigationController *navigationController =
        segue.destinationViewController;
        AddJobViewController *controller =
        (AddJobViewController *) navigationController;

        NSIndexPath *indexPath = [self.tableView
                                  indexPathForCell:sender];
        _jobsArray[indexPath.row] = sender;
        controller.jobToEdit = DataModel.myDataModel.jobsArray[indexPath.row];
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Task"]) {
        TaskViewController *destViewController = segue.destinationViewController;
        destViewController.job = sender;
        
        myJob = [DataModel.myDataModel.jobsArray objectAtIndex:myIndexPath.row];
//        destViewController.task = job.jobName;
        destViewController.title = @"Tasks";
        destViewController.job = myJob;
        destViewController.job.jobIndexPath = myIndexPath.row;
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
    
    JobTableViewCell *cell;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            [self performSegueWithIdentifier:@"EditJob" sender:self];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            [DataModel.myDataModel.jobsArray removeObjectAtIndex:cellIndexPath.row];
            
            NSArray *indexPaths = @[cellIndexPath];
            [self.tableView deleteRowsAtIndexPaths:indexPaths
                             withRowAnimation:UITableViewRowAnimationLeft];
            
            [self saveData];
            break;
        }
        default:
            break;
    }
}

-(void) segueToAddJobVC{
    [self performSegueWithIdentifier:@"EditJob" sender:self];
}

//- (void)navigationController:
//(UINavigationController *)navigationController
//      willShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animated
//{
//    if (viewController == self) {
//        [self.dataModel setIndexOfSelectedJob:-1];
//    }
//}


@end
