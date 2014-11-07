//
//  AddPersonViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "AddPersonViewController.h"
#import "SignInViewController.h"
#import "SignatureView.h"
#import "DataModel.h"
#import "Job.h"
#import "Task.h"
#import "Hazard.h"
#import "Person.h"
#import "HazardToBeCheckedTableViewCell.h"
#import "SolutionToBeCheckedTableViewCell.h"

@interface AddPersonViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *signBelowLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addSignatureButton;

@end

@implementation AddPersonViewController
{
    NSMutableArray *_localHazardArray;
    NSMutableArray *_localSolutionArray;
    int _count;
    Person *_localMainUser;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)Cancel {
    [self.delegate AddPersonViewControllerDidCancel:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.scrollView setScrollEnabled:YES];
    
    [self.signatureView setLineWidth:2.0];
    self.signatureView.foregroundLineColor = [UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1.000];
    [self.signatureView.layer setCornerRadius:5];
    
    self.navBarColor = [[UIColor alloc] initWithRed:.027344 green:.445313 blue:.898438 alpha:1];
    
    self.navigationController.navigationBar.barTintColor = self.navBarColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
  
    _localHazardArray = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray];
    
    if (self.personToEdit != nil) {
        self.navBar.title = @"Edit Person";
        self.fullNameTextField.text = self.personToEdit.fullName;
        self.signatureView.image = self.personToEdit.checkInSignature;
        if (self.personToEdit == DataModel.myDataModel.mainUser) {
            if (self.personToEdit.checkInSignature == nil) {
                self.addSignatureButton.title = @"Add Signature";
                self.addSignatureButton.enabled = NO;
                self.doneButton.enabled = NO;
            } else {
                self.addSignatureButton.title = @"Edit Signature";
                self.addSignatureButton.enabled = YES;
                self.doneButton.enabled = YES;
            }
        } else {
            self.addSignatureButton.title = @"Edit Signature";
            self.addSignatureButton.enabled = YES;
            self.doneButton.enabled = YES;
        }
        
    } else if (self.personToEdit == nil) {
        self.addSignatureButton.enabled = NO;
        self.doneButton.enabled = NO;        
    }
    self.signView.hidden = YES;
    [self.signView.layer setCornerRadius:5];
    
    }

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)doneButtonPressed:(id)sender {
    if (self.personToEdit == nil) {
        Person *person = [Person new];
        person.fullName = self.fullNameTextField.text;
        person.checkInSignature = [self.signatureView signatureImage];
        
        [self.delegate AddPersonViewController:self didFinishAddingItem:person];
    } else {
        self.personToEdit.fullName = self.fullNameTextField.text;
        self.personToEdit.checkInSignature = self.signatureView.image;
        [self.delegate AddPersonViewController:self didFinishEditingItem:self.personToEdit];
    }
    
}
- (IBAction)personNameAdded:(UITextField *)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.fullNameTextField resignFirstResponder];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([_localHazardArray count] *2);
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Review & Select Each Hazard to Check Off";
    } else {
        return @"";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        return 110;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        if (indexPath.row % 2) {
            NSString *CellIdentifier = @"SolutionCell";
            SolutionToBeCheckedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            Hazard *cellHazard = [_localHazardArray objectAtIndex:((indexPath.row - 1) / 2)];
            cell.solutionLabel.text = cellHazard.solution;
            if (self.personToEdit == nil) {
                cellHazard.solutionChecked = NO;
            } else if (self.personToEdit != nil) {
                if (self.personToEdit == DataModel.myDataModel.mainUser) {
                    if (self.personToEdit.checkInSignature == nil) {
                        cellHazard.checked = NO;
                    } else {
                        cellHazard.checked = YES;
                    }
                } else {
                    cellHazard.checked = YES;
                }
            }
            
            [self configureSolutionCheckmarkForCell:cell withChecklistItem:cellHazard];
            return cell;
        } else {
            NSString *CellIdentifier = @"HazardCell";
            HazardToBeCheckedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            Hazard *cellHazard = [_localHazardArray objectAtIndex:((indexPath.row) / 2)];
            cell.hazardLabel.text = cellHazard.hazardName;
            if (self.personToEdit == nil) {
                cellHazard.checked = NO;
            } else if (self.personToEdit != nil) {
                if (self.personToEdit == DataModel.myDataModel.mainUser) {
                    if (self.personToEdit == DataModel.myDataModel.mainUser) {
                        if (self.personToEdit.checkInSignature == nil) {
                            cellHazard.checked = NO;
                        } else {
                            cellHazard.checked = YES;
                        }
                    } else {
                        cellHazard.checked = YES;
                    }
            }
            }
            [self configureCheckmarkForCell:cell withChecklistItem:cellHazard];
            
            return cell;
        }
        
}

- (void)configureCheckmarkForCell:(HazardToBeCheckedTableViewCell *)cell
                withChecklistItem:(Hazard *)hazard //methods for checking and unchecking a cell/row
{
    cell.checkmarkLabel.textColor = [UIColor blueColor];
    
    if (hazard.checked) {
        cell.checkmarkLabel.text = @"√";
    } else {
        cell.checkmarkLabel.text = @"";
    }
}

- (void)configureSolutionCheckmarkForCell:(SolutionToBeCheckedTableViewCell *)cell
                withChecklistItem:(Hazard *)hazard //methods for checking and unchecking a cell/row
{
    cell.checkmarkLabel.textColor = [UIColor blueColor];
    
    if (hazard.solutionChecked) {
//        label.text = @"√";
        cell.checkmarkLabel.text = @"√";
    } else {
//        label.text = @"";
        cell.checkmarkLabel.text = @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    [self.fullNameTextField resignFirstResponder];
 
    if (indexPath.row % 2) {
        Hazard *cellHazard = [_localHazardArray objectAtIndex:((indexPath.row - 1) / 2)];
        SolutionToBeCheckedTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cellHazard = [_localHazardArray objectAtIndex:((indexPath.row - 1) / 2)];
        [cellHazard toggleSolutionChecked];
        [self configureSolutionCheckmarkForCell:cell withChecklistItem:cellHazard];
    } else {
        Hazard *cellHazard = [_localHazardArray objectAtIndex:((indexPath.row) / 2)];
        HazardToBeCheckedTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cellHazard = [_localHazardArray objectAtIndex:((indexPath.row) / 2)];
        [cellHazard toggleChecked];
        [self configureCheckmarkForCell:cell withChecklistItem:cellHazard];
    }
    
    [self countCheckedHazards];
    
    if (_count == ([_localHazardArray count]* 2)) {
        self.addSignatureButton.enabled = YES;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)clearButton:(UIButton *)sender {
    [self.signatureView clear];
    
}
- (IBAction)addSignature:(UIBarButtonItem *)sender {
    
    
    if ([self.addSignatureButton.title isEqualToString:@"Add Signature"]) {
        self.addSignatureButton.title = @"Close Signature View";
        self.doneButton.enabled = YES;
        self.signView.hidden = NO;
    } else if ([self.addSignatureButton.title isEqualToString:@"Close Signature View"]) {
        if (self.personToEdit == nil) {
            self.addSignatureButton.title = @"Add Signature";
        } else if (self.personToEdit != nil) {
        self.addSignatureButton.title = @"Edit Signature";
        }
        self.signView.hidden = YES;
    } else if ([self.addSignatureButton.title isEqualToString:@"Edit Signature"]) {
        self.addSignatureButton.title = @"Close Signature View";
        self.doneButton.enabled = YES;
        self.signView.hidden = NO;
    }
}

- (int)countCheckedHazards
{
    _count = 0;
    for (Hazard *hazard in _localHazardArray) {
        if (hazard.checked) {
            _count += 1;
        }
    }
    for (Hazard *hazard in _localHazardArray) {
        if (hazard.solutionChecked) {
            _count += 1;
        }
    }
    return _count;
}

@end
