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

@end

@implementation AddPersonViewController
{
    NSMutableArray *_localHazardArray;
    NSMutableArray *_localSolutionArray;
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
    
    if (_localHazardArray.count == 1) {
        _tableView.viewForBaselineLayout.frame = CGRectMake(0, 62, 320, 226);
        _tableView.contentSize = CGSizeMake(320, 226);
//        _tableView.viewForBaselineLayout.bounds = CGRectMake(0, 62, 320, 226);
    } else if (_localHazardArray.count > 1) {
        _tableView.viewForBaselineLayout.frame = CGRectMake(0, 62, 320, 426);
        _tableView.contentSize = CGSizeMake(320, 426);
        
//        _tableView.viewForBaselineLayout.bounds = CGRectMake(0, 62, 320, 426);
    }
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        if (indexPath.row % 2) {
            NSString *CellIdentifier = @"SolutionCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            UILabel *solutionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 250, 80)];
//            [solutionLabel setFont:[UIFont systemFontOfSize:17]];
//            [solutionLabel setEditable:NO];
            solutionLabel.numberOfLines = 0;
            solutionLabel.text = [[_localHazardArray objectAtIndex:((indexPath.row -1) / 2)] solution];
            
            [cell addSubview:solutionLabel];
            return cell;
        } else {
            NSString *CellIdentifier = @"HazardCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }

            UILabel *hazardLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 259, 30)];
            hazardLabel.text = [[_localHazardArray objectAtIndex:(indexPath.row / 2)] hazardName];
            
            [cell addSubview:hazardLabel];
            return cell;
        }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

- (IBAction)clearButton:(UIButton *)sender {
    [self.signatureView clear];
    
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
