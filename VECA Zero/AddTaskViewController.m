//
//  AddTaskViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 9/30/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "AddTaskViewController.h"
#import "Task.h"
#import "Hazard.h"
#import "AddHazardsViewController.h"

#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"])
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController
{
    NSDate *_date;
    
    BOOL _datePickerVisible;
    
    Task *_newTask;
    
    UIToolbar *_toolBar;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.taskNameTextField becomeFirstResponder];
    
    _date = [NSDate date];
    
    [self updateDueDateLabel];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    _newTask = [Task new];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTask)
                                                 name:@"saveAllTaskData"
                                               object:nil];
  
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(saveTask)
                                                   name:@"saveTaskData"
                                                 object:nil];
  
}

//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    [_toolBar setHidden:NO];
//    return YES;
//}
//
//-(IBAction)doneButtonTouched:(id)sender
//{
//    [self.taskNameTextField resignFirstResponder];
//    [_toolBar setHidden:YES];
//}

//-(void)viewWillAppear:(BOOL)animated {
//    [self.taskNameTextField becomeFirstResponder];
//}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.taskNameTextField resignFirstResponder];
//    [self.specificTaskLocationTextField resignFirstResponder];
//    [self.PrimaryEvacTextField resignFirstResponder];
//    [self.SecondaryEvacTextField resignFirstResponder];
//}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDueDateLabel
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.dateLabel.text = [formatter stringFromDate:_date];
}

- (IBAction)cancel {
    [self.delegate AddTaskViewControllerDidCancel:self];
//    [self saveTask];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewHazards"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddHazardsViewController *controller = (AddHazardsViewController *)navigationController;
        controller.delegate = self;
//        [self saveTask];
        controller.task = sender;
        controller.job = _job;
        controller.task = _task;
          if (_newTask.taskName == nil) {
            [self saveTask];
          } else {
            [self updateTask];
            controller.myTextField.text = [_newTask.hazardArray objectAtIndex:0];
          }
      
    }
}
- (IBAction)taskNameNext:(UITextField *)sender {
    [self performSegueWithIdentifier:@"NewHazards" sender:self];
}

//- (IBAction)nextButton:(UIBarButtonItem *)sender {
//    [self performSegueWithIdentifier:@"NewHazards" sender:self];
//}


-(void)saveTask {
//    Task *myTask = [[Task alloc] init];
    _newTask.taskName = self.taskNameTextField.text;
    _newTask.specificTaskLocation = self.specificTaskLocationTextField.text;
    _newTask.PrimaryEvacuation = self.PrimaryEvacTextField.text;
    _newTask.SecondaryEvacuation = self.SecondaryEvacTextField.text;
    _newTask.date = _date;
    
    [self.delegate AddTaskViewController:self didFinishAddingItem:_newTask];
}

-(void)updateTask {
  _newTask.taskName = self.taskNameTextField.text;
  _newTask.specificTaskLocation = self.specificTaskLocationTextField.text;
  _newTask.PrimaryEvacuation = self.PrimaryEvacTextField.text;
  _newTask.SecondaryEvacuation = self.SecondaryEvacTextField.text;
  _newTask.date = _date;
  
  [self.delegate AddTaskViewController:self didFinishEditingItem:_newTask];
  
}

#pragma mark - Table view data source

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        return indexPath;
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1
    if (indexPath.section == 1 && indexPath.row == 1) {
        // 2
        UITableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:@"DatePickerCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:@"DatePickerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // 3
            UIDatePicker *datePicker = [[UIDatePicker alloc]
                                        initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 216.0f)];
            datePicker.datePickerMode = UIDatePickerModeDate;
            datePicker.tag = 100;
            [cell.contentView addSubview:datePicker];
            // 4
            [datePicker addTarget:self action:@selector(dateChanged:)
                 forControlEvents:UIControlEventValueChanged];
        }
        return cell;
        // 5
    } else {
        return [super tableView:tableView
          cellForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 && _datePickerVisible) {
        return 2;
    } else {
        return [super tableView:tableView
          numberOfRowsInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
        return 217.0f;
    } else {
        return [super tableView:tableView
        heightForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
    [self.taskNameTextField resignFirstResponder];
    [self.specificTaskLocationTextField resignFirstResponder];
    [self.PrimaryEvacTextField resignFirstResponder];
    [self.SecondaryEvacTextField resignFirstResponder];
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (!_datePickerVisible) {
            [self showDatePicker];
        } else {
            [self hideDatePicker];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView
indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0
                                                       inSection:indexPath.section];
        return [super tableView:tableView
indentationLevelForRowAtIndexPath:newIndexPath];
    } else {
        return [super tableView:tableView
indentationLevelForRowAtIndexPath:indexPath];
    }
}

- (void)showDatePicker
{
    _datePickerVisible = YES;
    NSIndexPath *indexPathDateRow = [NSIndexPath
                                     indexPathForRow:0 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:1 inSection:1];
    UITableViewCell *cell = [self.tableView
                             cellForRowAtIndexPath:indexPathDateRow];
    cell.detailTextLabel.textColor = cell.detailTextLabel.tintColor;
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow]
                          withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    UITableViewCell *datePickerCell = [self.tableView
                                       cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker *)
    [datePickerCell viewWithTag:100];
    [datePicker setDate:_date animated:NO];
}

- (void)hideDatePicker
{
    if (_datePickerVisible) {
        _datePickerVisible = NO;
        NSIndexPath *indexPathDateRow = [NSIndexPath
                                         indexPathForRow:0 inSection:1];
        NSIndexPath *indexPathDatePicker = [NSIndexPath
                                            indexPathForRow:1 inSection:1];
        UITableViewCell *cell = [self.tableView
                                 cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor = [UIColor
                                          colorWithWhite:0.0f alpha:0.5f];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow]
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (void)dateChanged:(UIDatePicker *)datePicker
{
    _date = datePicker.date;
    [self updateDueDateLabel];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.taskNameTextField) {
        [self hideDatePicker];
    } else {
    [self hideDatePicker];
    }
}

-(void)AddHazardsViewController:(AddHazardsViewController *)controller didFinishAddingItem:(Hazard *)hazard {
    [_newTask.hazardArray addObject:hazard];
}

-(void)AddHazardsViewController:(AddHazardsViewController *)controller AndPersonsArray:(NSMutableArray *)myPersonArray {
    [_newTask.personArray addObjectsFromArray:myPersonArray];
}



@end
