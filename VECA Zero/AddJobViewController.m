//
//  AddJobViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "AddJobViewController.h"
#import "HistoryViewController.h"
#import "DataController.h"

@interface AddJobViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) IBOutlet UIImageView *jobTFBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *projectNumberTFBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *foremanNameTFBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *foremanEmailTFBackgroundImage;

@end

@implementation AddJobViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBarColor = [[UIColor alloc] initWithRed:.027344 green:.445313 blue:.898438 alpha:1];
    
    self.navigationController.navigationBar.barTintColor = self.navBarColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.cancelButton.tintColor = [UIColor whiteColor];
    self.doneBarButton.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIColor *color = [UIColor whiteColor];
    
    self.jobNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Job #" attributes:@{NSForegroundColorAttributeName: color}];
    self.projectNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Project Name" attributes:@{NSForegroundColorAttributeName: color}];
    self.foremanNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Foreman Name" attributes:@{NSForegroundColorAttributeName: color}];
    self.foremanEmailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Foreman Email" attributes:@{NSForegroundColorAttributeName: color}];
    
    [self.jobTFBackgroundImage.layer setCornerRadius:3];
    [self.projectNumberTFBackgroundImage.layer setCornerRadius:3];
    [self.foremanNameTFBackgroundImage.layer setCornerRadius:3];
    [self.foremanEmailTFBackgroundImage.layer setCornerRadius:3];
//    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [self.jobNumberTextField setLeftViewMode:UITextFieldViewModeAlways];
//    [self.jobNumberTextField setLeftView:spacerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.selectedJob.jobNumber = _jobNumberTextField.text;
//    self.selectedJob.jobName = _projectNameTextField.text;
//    self.selectedJob.foremanName = _foremanNameTextField.text;
//    self.selectedJob.foremanEmail = _foremanEmailTextField.text;
//    
//    
//    [[DataController sharedData] save];
//}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.selectedJob.jobNumber = _jobNumberTextField.text;
    self.selectedJob.jobName = _projectNameTextField.text;
    self.selectedJob.foremanName = _foremanNameTextField.text;
    self.selectedJob.foremanEmail = _foremanEmailTextField.text;
    
//    [[DataController sharedData] save];
    
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
