//
//  AddJobViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "AddJobViewController.h"
#import "JobsViewController.h"
#import "DataController.h"
#import "Task.h"

@interface AddJobViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) IBOutlet UIImageView *jobTFBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *projectNumberTFBackgroundImage;

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

- (IBAction)Cancel {
    [self.delegate AddJobViewControllerDidCancel:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
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
    
    self.doneBarButton.enabled = NO;
//    [self nameOfJobDoesExist];
    
    if (self.jobToEdit != nil) {
        self.navBar.title = @"Edit Job";
        self.jobNumberTextField.text = self.jobToEdit.jobNumber;
        self.projectNameTextField.text = self.jobToEdit.jobName;
        self.doneBarButton.enabled = YES;
    }
    
    

    [self.jobTFBackgroundImage.layer setCornerRadius:3];
    [self.projectNumberTFBackgroundImage.layer setCornerRadius:3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (IBAction)jobNameAdded:(UITextField *)sender {
    [self nameOfJobDoesExist];
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
    if (self.jobToEdit == nil) {
        Job *job = [[Job alloc] init];
        job.jobName = self.projectNameTextField.text;
        job.jobNumber = self.jobNumberTextField.text;
        [self.delegate AddJobViewController:self didFinishAddingItem:job];
    } else {
        self.jobToEdit.jobName = self.projectNameTextField.text;
        self.jobToEdit.jobNumber = self.jobNumberTextField.text;
        [self.delegate AddJobViewController:self didFinishEditingItem:self.jobToEdit];
    }
    
//    [[DataController sharedData] save];
    
}

//- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *newText = [self.projectNameTextField.text stringByReplacingCharactersInRange:range withString:string];
//    self.doneBarButton.enabled = ([newText length] > 0);
//    return YES;
//}

- (void)nameOfJobDoesExist {
    if ([self.projectNameTextField.text length] > 0) {
        self.doneBarButton.enabled = YES;
    } else {
        self.doneBarButton.enabled = NO;
    }
}

@end
