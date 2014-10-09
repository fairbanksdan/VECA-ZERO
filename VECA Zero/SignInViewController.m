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


@end

@implementation SignInViewController
{
    NSMutableArray *_persons; //creates a mutable Array with the variable "_items"
    Job *_job;
    Task *_task;
    Hazard *_hazard;
    NSMutableArray *_newHazardsArray;
}
//
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
//            stringByAppendingPathComponent:@"VECA Zero Person.plist"];
//}
//
//- (void)savePersons
//{
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
//                                 initForWritingWithMutableData:data];
//    [archiver encodeObject:_persons forKey:@"Persons"];
//    [archiver finishEncoding];
//    [data writeToFile:[self dataFilePath] atomically:YES];
//}
//
//- (void)loadPersons
//{
//    NSString *path = [self dataFilePath];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
//                                         initForReadingWithData:data];
//        _persons = [unarchiver decodeObjectForKey:@"Persons"];
//        
//        [unarchiver finishDecoding];
//    } else {
//        _persons = [[NSMutableArray alloc] initWithCapacity:20];
//    }
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if ((self = [super initWithCoder:aDecoder])) {
//        [self loadPersons];
//    }
//    return self;
//}
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"Documents folder is %@", [self documentsDirectory]);
//    NSLog(@"Data file path is %@", [self dataFilePath]);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.saveTaskButton.layer setCornerRadius:5];
    
    [self.delegate SignInViewController:self didFinishSavingPersonArray:_persons];
    
    _persons = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray];
    
    NSLog(@"Check In VC _job.jobIndexPath is: %lu", _job.jobIndexPath);
    NSLog(@"Check In VC _task.jobIndexPath is: %lu", _task.taskIndexPath);
//    
//    Person *person1 = [Person new];
//    person1.fullName = @"Dan Fairbanks";
//    
//    [self.personArray addObject:person1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    Person *person = _persons[indexPath.row];
    [self configureTextForCell:cell withPersonName:person];
    
    return cell;
    
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
//    }
//    if (indexPath.row == 0) {
//        Person *person = [self.personArray objectAtIndex:indexPath.row];
//        cell.textLabel.text = person.fullName;
//    } else {
//        cell.textLabel.text = @"Add New Person";
//    }
//    
//    return cell;
}

- (void)AddPersonViewController:(AddPersonViewController *)controller didFinishAddingItem:(Person *)person {
    NSInteger newRowIndex = [_persons count];
    [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] addObject:person];
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
    
//    NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
//    
//    Person *myPerson;
    
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
//        controller.personToEdit = [Person new];
        controller.personToEdit = _persons[indexPath.row];
//        controller.fullNameTextField.text = controller.personToEdit.fullName;
//        controller.signatureView.image = controller.personToEdit.checkInSignature;
        controller.delegate = self;
        NSLog(@"Edit Person");
    } else if ([segue.identifier isEqualToString:@"MidTask"]) {
        MidTaskViewController *destViewController = segue.destinationViewController;
        destViewController.job = _job;
        destViewController.task = _task;
        destViewController.task.personArray = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray];
//        myPerson = [_persons objectAtIndex:myIndexPath.row];
//        destViewController.person = myPerson;
      
        
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
            NSLog(@"Edit button was pressed");
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            Person *person = _persons[cellIndexPath.row];
            
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
            
//            [self savePersons];
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

    
    NSLog(@"_persons array in Check In VC is: %lu", [_persons count]);
}

@end
