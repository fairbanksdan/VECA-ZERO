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
@property (strong, nonatomic) DataController *myDataController;

@end

@implementation JobsViewController
{
    NSMutableArray *_lists; //creates a mutable Array with the variable "_items"
    DataModel *_dataModel;
}

//- (NSString *)documentsDirectory
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(
//                                                         NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths firstObject];
//    return documentsDirectory;
//}
//
//- (NSString *)dataFilePath
//{
//    return [[self documentsDirectory]
//            stringByAppendingPathComponent:@"VECA Zero.plist"];
//}
//
//- (void)saveJobs
//{
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
//                                 initForWritingWithMutableData:data];
//    [archiver encodeObject:_items forKey:@"Jobs"];
//    [archiver finishEncoding];
//    [data writeToFile:[self dataFilePath] atomically:YES];
//}
//
//- (void)loadJobs
//{
//    NSString *path = [self dataFilePath];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
//                                         initForReadingWithData:data];
//        _items = [unarchiver decodeObjectForKey:@"Jobs"];
//        
//        [unarchiver finishDecoding];
//    } else {
//        _items = [[NSMutableArray alloc] initWithCapacity:20];
//    }
//}
//

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"Documents folder is %@", [self documentsDirectory]);
//    NSLog(@"Data file path is %@", [self dataFilePath]);
    
//    _items = [NSMutableArray new];
    
//    Job *job;
//    
//    job = [Job new];
//    
//    job.jobName = @"Job 1";
//    job.jobNumber = @"12123";
//    [_items addObject:job];
    
    
//    self.myDataController = [[DataController sharedData] initWithJobs];
    
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
    [_dataModel saveJobs];
}

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
    return  [self.dataModel.tasksForJobs count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Job *job = self.dataModel.tasksForJobs[indexPath.row];
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
    
    Job *job = self.dataModel.tasksForJobs[indexPath.row];
    [self configureTextForCell:cell withJobName:job];
    
    return cell; //returns what is in each "cell" as defined in this method
}

- (void)AddJobViewController:(AddJobViewController *)controller
         didFinishAddingItem:(Job *)job; {
    NSInteger newRowIndex = [self.dataModel.tasksForJobs count];
    [self.dataModel.tasksForJobs insertObject:job atIndex:0];
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
    NSInteger index = [self.dataModel.tasksForJobs indexOfObject:job];
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
    
//    NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
//    
//    Job *myJob;
    
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
        NSLog(@"AddJob Segue");
    } else if ([segue.identifier isEqualToString:@"EditJob"])
    {
        UINavigationController *navigationController =
        segue.destinationViewController;
        AddJobViewController *controller =
        (AddJobViewController *)
        navigationController;
        
        NSIndexPath *indexPath = [self.tableView
                                  indexPathForCell:sender];
        controller.jobToEdit = [Job new];
        
        controller.jobToEdit = self.dataModel.tasksForJobs[indexPath.row];
        controller.jobNumberTextField.text = controller.jobToEdit.jobNumber;
        controller.projectNameTextField.text = controller.jobToEdit.jobName;
        controller.delegate = self;
        NSLog(@"EditJob Segue");
    } else if ([segue.identifier isEqualToString:@"Task"]) {
        NSLog(@"Task Segue");
        TaskViewController *destViewController = segue.destinationViewController;
        destViewController.job = sender;
//        self.dataModel.tasksForJobs = sender;
////        myJob = [self.dataModel.tasksForJobs objectAtIndex:myIndexPath.row];
        //destViewController.tasks = job.jobName;
        destViewController.title = @"Tasks";
//        destViewController.job = myJob;
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
            NSLog(@"Edit button was pressed");
            [self segueToAddJobVC];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            [self.dataModel.tasksForJobs removeObjectAtIndex:cellIndexPath.row];
            
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




@end
