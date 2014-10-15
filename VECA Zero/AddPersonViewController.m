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
//    [self.scrollView setContentSize:CGSizeMake(320, 700)];
    
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
    }
    
    self.signView.hidden = YES;
    [self.signView.layer setCornerRadius:5];
    
    self.doneButton.enabled = NO;
    self.addSignatureButton.enabled = NO;
//    self.signatureView.hidden = YES;
//    self.signBelowLabel.hidden = YES;
//    self.clearButton.hidden = YES;
    
    
        
//        _tableView.viewForBaselineLayout.bounds = CGRectMake(0, 62, 320, 426);
    
    
}

//-(void)viewWillAppear:(BOOL)animated {
//    if (_localHazardArray.count == 1) {
//        _tableView.frame = CGRectMake(0, 62, 320, 226);
//        _tableView.contentSize = CGSizeMake(320, 226);
//        
//        //        _tableView.viewForBaselineLayout.bounds = CGRectMake(0, 62, 320, 226);
//    } else if (_localHazardArray.count > 1) {
//        CGRect tableViewFrame = [_tableView frame];
//        [_tableView setFrame:CGRectMake(tableViewFrame.origin.x, tableViewFrame.origin.y, tableViewFrame.size.width, tableViewFrame.size.height +200)];
//        [_tableView setContentSize:CGSizeMake(tableViewFrame.size.width, tableViewFrame.size.height +200)];
////        _tableView.frame = CGRectMake(0, 62, 320, 426);
////        _tableView.contentSize = CGSizeMake(320, 426);
//    }
//}

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([_localHazardArray count] *2);
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Review and Check Off Hazards";
    } else {
        return @"";
    }
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
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            UILabel *solutionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 250, 80)];
//            [solutionLabel setFont:[UIFont systemFontOfSize:17]];
//            [solutionLabel setEditable:NO];
            Hazard *cellHazard = [_localHazardArray objectAtIndex:((indexPath.row - 1) / 2)];
            cellHazard.solutionChecked = NO;
            
            solutionLabel.numberOfLines = 0;
            solutionLabel.text = cellHazard.solution;
            
            [cell addSubview:solutionLabel];
            [self configureSolutionCheckmarkForCell:cell withChecklistItem:cellHazard];
            return cell;
        } else {
            NSString *CellIdentifier = @"HazardCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            Hazard *cellHazard = [_localHazardArray objectAtIndex:((indexPath.row) / 2)];
            cellHazard.checked = NO;

            UILabel *hazardLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 250, 30)];
            hazardLabel.text = cellHazard.hazardName;
            [self configureCheckmarkForCell:cell withChecklistItem:cellHazard];
            
            [cell addSubview:hazardLabel];
            return cell;
        }
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell
                withChecklistItem:(Hazard *)hazard //methods for checking and unchecking a cell/row
{
    UILabel *label = (UILabel *)[cell viewWithTag:1004];
    
    label.textColor = [UIColor blueColor];
    
    if (hazard.checked) {
        label.text = @"√";
    } else {
        label.text = @"";
    }
}

- (void)configureSolutionCheckmarkForCell:(UITableViewCell *)cell
                withChecklistItem:(Hazard *)hazard //methods for checking and unchecking a cell/row
{
    UILabel *label = (UILabel *)[cell viewWithTag:1005];
    
    label.textColor = [UIColor blueColor];
    
    if (hazard.solutionChecked) {
        label.text = @"√";
    } else {
        label.text = @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSIndexPath *cellIndexPath = [self.tableView indexPathForSelectedRow];
//    
//    NSMutableArray *checkedHazardsArray = [[NSMutableArray alloc] initWithCapacity:([_localHazardArray count] *2)];
//    NSMutableArray *myHazardsArray = [[NSMutableArray alloc] initWithCapacity:20];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    int count;
//    count = 1;
//    
//    NSString *newString = [NSString new];
//    [myHazardsArray addObject:newString];
//    
//    if (cell.accessoryType == UITableViewCellAccessoryNone) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
////        NSMutableArray *myArray = [[NSMutableArray alloc] initWithCapacity:20];
////        NSString *string = [NSString new];
////        [myHazardsArray addObject:string];
////        for (int i = 0; i < count; i++) {
////            
//////            NSString *newString = [NSString new];
//////            [checkedHazardsArray addObject:newString];
////            NSString *string = [NSString new];
////            [checkedHazardsArray addObject:string];
//////        }
//////        if (cellIndexPath.row > ([checkedHazardsArray count] +1)) {
//////        NSString *string = [NSString new];
//////        [checkedHazardsArray addObjectsFromArray:myHazardsArray];
//////        }
////            count += 1;
////        NSLog(@"checkHazardsArray count is: %lu", [checkedHazardsArray count]);
//        //}
//        
//        
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
////        [checkedHazardsArray removeObjectAtIndex:([checkedHazardsArray count])];
//    }
    
    
//    if ([checkedHazardsArray count] == ([_localHazardArray count] *2)) {
//        self.doneButton.enabled = YES;
//    } else if ([checkedHazardsArray count] < ([_localHazardArray count] *2)) {
//        self.doneButton.enabled = NO;
//    }
    
    Hazard *hazard = [Hazard new];
    
    if (indexPath.row % 2) {
        hazard = [_localHazardArray objectAtIndex:((indexPath.row - 1) / 2)];
        [hazard toggleSolutionChecked];
        [self configureSolutionCheckmarkForCell:cell withChecklistItem:hazard];
    } else {
        hazard = [_localHazardArray objectAtIndex:((indexPath.row) / 2)];
        [hazard toggleChecked];
        [self configureCheckmarkForCell:cell withChecklistItem:hazard];
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
        self.addSignatureButton.title = @"Add Signature";
//        self.doneButton.enabled = NO;
        self.signView.hidden = YES;
    }
    
//    UIBarButtonItem *closeSignView = [[UIBarButtonItem alloc] initWithTitle:@"Close Signature View" style:UIBarButtonItemStylePlain target:self action:nil];
//    self.toolBar.hidden = YES;
//    self.signatureView.hidden = NO;
//    self.signBelowLabel.hidden = NO;
//    self.clearButton.hidden = NO;
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
