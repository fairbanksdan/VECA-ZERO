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
#import "HazardsViewController.h"

#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"])
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

@interface AddTaskViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *energizedSwitch;

@end

@implementation AddTaskViewController
{
    NSDate *_date;
    BOOL _datePickerVisible;
    Task *_newTask;
    UIToolbar *_toolBar;
    UIAlertController *energizedAlert;
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
                                               selector:@selector(saveTask)
                                                   name:@"saveTaskData"
                                                 object:nil];
    if ([self.taskNameTextField.text length] > 0) {
        self.nextBarButton.enabled = YES;
    } else {
        self.nextBarButton.enabled = NO;
    }
}

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
    self.dateLabel.text = [formatter stringFromDate:_date];
}

- (IBAction)cancel {
    [self.delegate AddTaskViewControllerDidCancel:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewHazards"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        HazardsViewController *controller = (HazardsViewController *)navigationController;

        controller.task = sender;
        controller.job = _job;
        controller.task = _task;
          if (_newTask.taskName == nil) {
            [self saveTask];
          }
    }
}
- (IBAction)taskNameNext:(UITextField *)sender {
    [self performSegueWithIdentifier:@"NewHazards" sender:self];
}


-(void)saveTask {
    _newTask.taskName = self.taskNameTextField.text;
    _newTask.specificTaskLocation = self.specificTaskLocationTextField.text;
    _newTask.PrimaryEvacuation = self.PrimaryEvacTextField.text;
    _newTask.SecondaryEvacuation = self.SecondaryEvacTextField.text;
    _newTask.date = _date;
    
    [self.delegate AddTaskViewController:self didFinishAddingItem:_newTask];
}

//-(void)updateTask {
//  _newTask.taskName = self.taskNameTextField.text;
//  _newTask.specificTaskLocation = self.specificTaskLocationTextField.text;
//  _newTask.PrimaryEvacuation = self.PrimaryEvacTextField.text;
//  _newTask.SecondaryEvacuation = self.SecondaryEvacTextField.text;
//  _newTask.date = _date;
//  
//  [self.delegate AddTaskViewController:self didFinishEditingItem:_newTask];
//  
//}

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
    if (indexPath.section == 1 && indexPath.row == 1) {

        UITableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:@"DatePickerCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:@"DatePickerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UIDatePicker *datePicker = [[UIDatePicker alloc]
                                        initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 216.0f)];
            datePicker.datePickerMode = UIDatePickerModeDate;
            datePicker.tag = 100;
            [cell.contentView addSubview:datePicker];

            [datePicker addTarget:self action:@selector(dateChanged:)
                 forControlEvents:UIControlEventValueChanged];
        }
        return cell;
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
- (IBAction)taskNameChanged:(UITextField *)sender {

        if ([self.taskNameTextField.text length] > 0) {
            self.nextBarButton.enabled = YES;
        } else {
            self.nextBarButton.enabled = NO;
        }
}
- (IBAction)energizedWorkToggle:(UISwitch *)sender {
    if(self.energizedSwitch.isOn == YES) {

        energizedAlert = [UIAlertController alertControllerWithTitle:@"Energized Work" message:@"Please fill out a method of procedure form and submit to the safety department" preferredStyle:UIAlertControllerStyleAlert];
            
        UIAlertAction *cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     [energizedAlert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [energizedAlert addAction:cancel];
        
        [self presentViewController:energizedAlert animated:YES completion:nil];
    }
}

@end
