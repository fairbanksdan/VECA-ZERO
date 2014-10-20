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
#import "Task.h"
#import "Job.h"
#import "NSMutableArray+SWUtilityButtons.h"
#import "SWTableViewCell.h"
#import "JobTableViewCell.h"
#import "DataModel.h"
#import "AppDelegate.h"

@interface JobsViewController  () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddJobBarButton;
@property (weak, nonatomic) IBOutlet UISearchBar *jobSearchBar;
@property (strong, nonatomic) NSMutableArray *filteredJobArray;
@property (weak, nonatomic) IBOutlet UIButton *addJobButton;

@end

@implementation JobsViewController
{
    NSMutableArray *_lists; //creates a mutable Array with the variable "_items"
    DataModel *_sharedDataModel;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.filteredJobArray = [[NSMutableArray alloc] initWithCapacity:[DataModel.myDataModel.jobsArray count]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navBarColor = [[UIColor alloc] initWithRed:.027344 green:.445313 blue:.898438 alpha:1];
    
    self.navigationController.navigationBar.barTintColor = self.navBarColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.AddJobBarButton.tintColor = [UIColor whiteColor];
    
    [self.addJobButton.layer setCornerRadius:5];
    
    NSLog(@"Main User is: %@", DataModel.myDataModel.mainUser.fullName);
}

//-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
//    NSPredicate *predicate = [NSPredicate
//                              predicateWithFormat:@"SELF.firstName contains[c] %@",
//                              searchText];
//    NSArray *filteredArray = [allPatientDetails filteredArrayUsingPredicate:predicate];
//    [tableView reloadData];
//}

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

- (void)configureTextForCell:(JobTableViewCell *)cell
           withJobName:(Job *)job
{
//    UILabel *label = (UILabel *)[cell viewWithTag:1000];
//    label.text = job.jobName;
//    cell.jobName.textColor = [UIColor blackColor];
    cell.jobName.text = job.jobName;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredJobArray count];
    } else {
        return  [DataModel.myDataModel.jobsArray count];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Job *job = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        job = self.filteredJobArray[indexPath.row];
        NSLog(@"SearchTableView filteredJobArray IndexPath.row is: %@", [self.filteredJobArray[indexPath.row] jobName]);
    } else {
        job = DataModel.myDataModel.jobsArray[indexPath.row];
    }
    [self performSegueWithIdentifier:@"Task" sender:job];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"JobCell";
    
    JobTableViewCell *cell = (JobTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[JobTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
    
//    if (cell.rightUtilityButtons) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }

    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobCell"];
    
    Job *job = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        job = [self.filteredJobArray objectAtIndex:indexPath.row];
        cell.textLabel.text = job.jobName;
    } else {
        job = DataModel.myDataModel.jobsArray[indexPath.row];
    }
//    
//    cell.jobName.text = job.jobName;
    
    [self configureTextForCell:cell withJobName:job];
    
    return cell; //returns what is in each "cell" as defined in this method
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(JobTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//}

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
    JobTableViewCell *cell = [self.tableView
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

//    Job *myJob = [Job new];
    
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
        if (sender == nil) {
            controller.jobToEdit = DataModel.myDataModel.jobsArray[indexPath.row];
        } else {
            controller.jobToEdit = sender;
        }
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Task"]) {
        TaskViewController *destViewController = segue.destinationViewController;
        
        
        if (self.tableView == self.searchDisplayController.searchResultsTableView) {
//            if (sender == nil) {
                destViewController.job = sender;
//            } else {
//                destViewController.job = sender;
//            }
        } else {
            if (sender == nil) {
                destViewController.job = DataModel.myDataModel.jobsArray[myIndexPath.row];
            } else {
                destViewController.job = sender;
            }
        }
//        myJob = [DataModel.myDataModel.jobsArray objectAtIndex:myIndexPath.row];
//        destViewController.task = job.jobName;
        destViewController.title = @"Tasks";
//        destViewController.job = myJob;
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
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            Job *job = [DataModel.myDataModel.jobsArray objectAtIndex:cellIndexPath.row];
            [self performSegueWithIdentifier:@"EditJob" sender:job];
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
- (IBAction)addJobButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"AddJob" sender:self];
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredJobArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.jobName contains[c] %@",searchText];
    self.filteredJobArray = [NSMutableArray arrayWithArray:[DataModel.myDataModel.jobsArray filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
- (IBAction)editUser:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
