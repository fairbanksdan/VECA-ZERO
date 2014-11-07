//
//  AddJobViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "AddJobViewController.h"
#import "JobsViewController.h"
#import "Task.h"

@interface AddJobViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) IBOutlet UIImageView *jobTFBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *projectNumberTFBackgroundImage;
@property (nonatomic) BOOL iPhone4S;
@property (nonatomic) BOOL iPhone5;
@property (nonatomic) BOOL iPhone6;
@property (nonatomic) BOOL iPhone6Plus;
@property (nonatomic) BOOL iPad;
@property (strong, nonatomic) IBOutlet UIView *addJobView;

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
    
    if (self.jobToEdit != nil) {
        self.navBar.title = @"Edit Job";
        self.jobNumberTextField.text = self.jobToEdit.jobNumber;
        self.projectNameTextField.text = self.jobToEdit.jobName;
        self.doneBarButton.enabled = YES;
    }
    
    [self.jobTFBackgroundImage.layer setCornerRadius:3];
    [self.projectNumberTFBackgroundImage.layer setCornerRadius:3];
    
    if (self.view.frame.size.height <= 480) {
        self.iPhone4S = YES;
    } else if (self.view.frame.size.height <= 568) {
        self.iPhone5 = YES;
    } else if (self.view.frame.size.height <= 667) {
        self.iPhone6 = YES;
    } else if (self.view.frame.size.height <= 960) {
        self.iPhone6Plus = YES;
    } else if (self.view.frame.size.height <= 1024) {
        self.iPad = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self.jobNumberTextField becomeFirstResponder];
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
}

- (void)nameOfJobDoesExist {
    if ([self.projectNameTextField.text length] > 0) {
        self.doneBarButton.enabled = YES;
    } else {
        self.doneBarButton.enabled = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSInteger startPoint;
    NSInteger startPointTwo;
    NSInteger offset;
    NSInteger inset;
    
    if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        if (self.iPhone4S) {
            startPoint = 0;
            startPointTwo = 0;
            offset = 10;
            inset = 280;
            
        } else if (self.iPhone5) {
            startPoint = 0;
            startPointTwo = 0;
            offset = 10;
            inset = 280;
        } else {
            startPoint = 0;
            startPointTwo = 0;
            offset = 60;
            inset = 280;
        }
        
        if (textField.frame.origin.y > startPoint) {
            [self.addJobView setContentOffset:CGPointMake(0, textField.frame.origin.y - offset) animated:YES];
            
        }
    
}

@end
