//
//  HomeViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "HomeViewController.h"
#import "JobsViewController.h"

@interface HomeViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *EmailTextField;
@property (strong,nonatomic) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.textFields = @[self.EmailTextField, self.nameTextField];
    
    UITapGestureRecognizer *tapOutside = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.scrollView addGestureRecognizer:tapOutside];
    
    UIColor *color = [UIColor whiteColor];
    
    self.EmailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName: color}];
    
    [self.continueButton.layer setCornerRadius:5];
    
    if (DataModel.myDataModel.mainUser != nil) {
        self.nameTextField.text = DataModel.myDataModel.mainUser.fullName;
    } else {
        self.nameTextField.text = nil;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView commitAnimations];
    
    for (UITextField *textField in self.textFields)
    {
        [textField resignFirstResponder];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.frame.origin.y > 0)
    {
        [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y - 84) animated:YES];
    }
    
    if (textField.frame.origin.y > 0) {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 260, 0);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)continueButton:(UIButton *)sender {
    DataModel.myDataModel.mainUser.fullName = self.nameTextField.text;
    DataModel.myDataModel.mainUser.checkInSignature = nil;
    
    [DataModel.myDataModel saveJobs];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Jobs"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        JobsViewController *controller = (JobsViewController *)navigationController.topViewController;
    }
    
}

@end
