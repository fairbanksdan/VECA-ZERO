//
//  AddTaskViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 9/30/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "AddTaskViewController.h"
#import "Task.h"

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController
{
    NSDate *_date;
    BOOL _datePickerVisible;
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
    
    _date = [NSDate date];
    
    [self updateDueDateLabel];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
}

- (IBAction)next {
    Task *task = [Task new];
    task.taskName = self.taskNameTextField.text;
    task.specificTaskLocation = self.specificTaskLocationTextField.text;
    task.PrimaryEvacuation = self.PrimaryEvacTextField.text;
    task.SecondaryEvacuation = self.SecondaryEvacTextField.text;
    task.date = _date;
    NSLog(@"Next Button Pressed");
    
    [self.delegate AddTaskViewController:self didFinishAddingItem:task];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewHazards"]) {
        [self saveTask];
    }
}

-(void)saveTask {
    Task *task = [Task new];
    task.taskName = self.taskNameTextField.text;
    task.specificTaskLocation = self.specificTaskLocationTextField.text;
    task.PrimaryEvacuation = self.PrimaryEvacTextField.text;
    task.SecondaryEvacuation = self.SecondaryEvacTextField.text;
    task.date = _date;
    NSLog(@"Next Button Pressed");
    
    [self.delegate AddTaskViewController:self didFinishAddingItem:task];
}

//- (void)saveTask {
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

@end
