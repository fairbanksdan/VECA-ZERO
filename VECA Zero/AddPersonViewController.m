//
//  AddPersonViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "AddPersonViewController.h"
#import "SignInViewController.h"


@interface AddPersonViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end

@implementation AddPersonViewController

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
    
    self.navBarColor = [[UIColor alloc] initWithRed:.027344 green:.445313 blue:.898438 alpha:1];
    
    self.navigationController.navigationBar.barTintColor = self.navBarColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    if (self.personToEdit != nil) {
        self.navBar.title = @"Edit Person";
        self.fullNameTextField.text = self.personToEdit.fullName;
    }
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)doneButtonPressed:(id)sender {
    if (self.personToEdit == nil) {
        Person *person = [Person new];
        person.fullName = self.fullNameTextField.text;
        [self.delegate AddPersonViewController:self didFinishAddingItem:person];
    } else {
        self.personToEdit.fullName = self.fullNameTextField.text;
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
    return 2;
    
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
        return 88;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        if (indexPath.row == 0) {
            NSString *CellIdentifier = @"HazardCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            return cell;
        } else {
            NSString *CellIdentifier = @"SolutionCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            return cell;
        }
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
