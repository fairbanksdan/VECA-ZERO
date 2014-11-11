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

@property (strong,nonatomic) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) BOOL iPhone4S;
@property (nonatomic) BOOL iPhone5;
@property (nonatomic) BOOL iPhone6;
@property (nonatomic) BOOL iPhone6Plus;
@property (nonatomic) BOOL iPad;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.textFields = @[self.nameTextField];
    
    UITapGestureRecognizer *tapOutside = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.scrollView addGestureRecognizer:tapOutside];
    
    UIColor *color = [UIColor whiteColor];
    
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName: color}];
    
    [self.continueButton.layer setCornerRadius:5];
    
    if (DataModel.myDataModel.mainUser != nil) {
        self.nameTextField.text = DataModel.myDataModel.mainUser.fullName;
    } else {
        self.nameTextField.text = nil;
    }
    if (([self.nameTextField.text length]) > 0) {
        self.continueButton.enabled = YES;
    } else {
        self.continueButton.enabled = NO;
    }
    
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        if (self.view.frame.size.height <= 480) {
            self.iPhone4S = YES;
        } else if (self.view.frame.size.height <= 568) {
            self.iPhone5 = YES;
        } else if (self.view.frame.size.height <= 667) {
            self.iPhone6 = YES;
        } else if (self.view.frame.size.height <= 736) {
            self.iPhone6Plus = YES;
        } else if (self.view.frame.size.height <= 1024) {
            self.iPad = YES;
        }
    } else {
        if (self.view.frame.size.height <= 320 && self.view.frame.size.width <= 480) {
            self.iPhone4S = YES;
        } else if (self.view.frame.size.height <= 320 && self.view.frame.size.width <= 568) {
            self.iPhone5 = YES;
        } else if (self.view.frame.size.height <= 375) {
            self.iPhone6 = YES;
        } else if (self.view.frame.size.height <= 414) {
            self.iPhone6Plus = YES;
        } else if (self.view.frame.size.height <= 768) {
            self.iPad = YES;
        }
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

- (void)viewDidAppear:(BOOL)animated
{
    [self updateLayoutForNewOrientation:self.interfaceOrientation];
    [super viewDidAppear:animated];
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
    NSInteger startPoint;
    NSInteger startPointTwo;
    NSInteger offset;
    NSInteger inset;
    NSInteger buttonEndPoint;
    
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
        } else if (self.iPhone6 || self.iPhone6Plus) {
            startPoint = 0;
            startPointTwo = 0;
            offset = 60;
            inset = 280;
        } else {
            startPoint = 0;
            startPointTwo = 0;
            offset = 200;
            inset = 280;
        }
        
    } else {
        if (self.iPhone4S) {
            startPoint = 0;
            startPointTwo = 0;
            offset = 100;
            inset = 260;
            
        } else if (self.iPhone5) {
            startPoint = 0;
            startPointTwo = 0;
            offset = 180;
            inset = 260;
        } else if (self.iPhone6 || self.iPhone6Plus) {
            startPoint = 0;
            startPointTwo = 0;
            offset = 233;
            inset = 260;
        } else {
            startPoint = 0;
            startPointTwo = 0;
            offset = 368;
            inset = 260;
        }
        
    }

    if (textField.frame.origin.y > startPoint)
    {
        [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y - offset) animated:YES];
        
        if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
            if (self.iPhone4S) {
                buttonEndPoint = 210;
            } else if (self.iPhone5) {
                buttonEndPoint = 210;
            } else if (self.iPhone6) {
                buttonEndPoint = 210;
            } else if (self.iPhone6Plus) {
                buttonEndPoint = 235;
            } else if (self.iPad) {
                buttonEndPoint = 460;
            }
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5f];
            [self.continueButton setFrame:CGRectMake(self.continueButton.frame.origin.x, buttonEndPoint, self.continueButton.frame.size.width, self.continueButton.frame.size.height)];
            [UIView commitAnimations];
        } else {
            if (self.iPhone4S) {
                buttonEndPoint = 310;
            } else if (self.iPhone5) {
                buttonEndPoint = 315;
            } else if (self.iPhone6) {
                buttonEndPoint = 350;
            } else if (self.iPhone6Plus) {
                buttonEndPoint = 395;
            } else if (self.iPad) {
                buttonEndPoint = 564;
            }
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5f];
            [self.continueButton setFrame:CGRectMake(self.continueButton.frame.origin.x, buttonEndPoint, self.continueButton.frame.size.width, self.continueButton.frame.size.height)];
            [UIView commitAnimations];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        if (self.iPad) {
            [self.continueButton setFrame:CGRectMake(self.continueButton.frame.origin.x, 564, self.continueButton.frame.size.width, self.continueButton.frame.size.height)];
            [UIView commitAnimations];
        } else {
            [self.continueButton setFrame:CGRectMake(self.continueButton.frame.origin.x, 255, self.continueButton.frame.size.width, self.continueButton.frame.size.height)];
            [UIView commitAnimations];
        }
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        if (self.iPad) {
            [self.continueButton setFrame:CGRectMake(self.continueButton.frame.origin.x, 564, self.continueButton.frame.size.width, self.continueButton.frame.size.height)];
            [UIView commitAnimations];
        } else {
            [self.continueButton setFrame:CGRectMake(self.continueButton.frame.origin.x, 423, self.continueButton.frame.size.width, self.continueButton.frame.size.height)];
            [UIView commitAnimations];
        }
    }
}

-(void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation {
    if ([self.nameTextField isFirstResponder]) {
        NSInteger startPoint;
        NSInteger startPointTwo;
        NSInteger offset;
        NSInteger inset;
        NSInteger buttonEndPoint;
        
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
            } else if (self.iPhone6 || self.iPhone6Plus) {
                startPoint = 0;
                startPointTwo = 0;
                offset = 60;
                inset = 280;
            } else {
                startPoint = 0;
                startPointTwo = 0;
                offset = 200;
                inset = 280;
            }
        } else {
            if (self.iPhone4S) {
                startPoint = 0;
                startPointTwo = 0;
                offset = 100;
                inset = 260;
                
            } else if (self.iPhone5) {
                startPoint = 0;
                startPointTwo = 0;
                offset = 180;
                inset = 260;
            } else if (self.iPhone6 || self.iPhone6Plus) {
                startPoint = 0;
                startPointTwo = 0;
                offset = 233;
                inset = 260;
            } else {
                startPoint = 0;
                startPointTwo = 0;
                offset = 368;
                inset = 260;
            }
            
        }
        
        if (self.nameTextField.frame.origin.y > startPoint)
        {
            [self.scrollView setContentOffset:CGPointMake(0, self.nameTextField.frame.origin.y - offset) animated:YES];
            
            if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
                if (self.iPhone4S) {
                    buttonEndPoint = 210;
                } else if (self.iPhone5) {
                    buttonEndPoint = 210;
                } else if (self.iPhone6) {
                    buttonEndPoint = 210;
                } else if (self.iPhone6Plus) {
                    buttonEndPoint = 235;
                } else if (self.iPad) {
                    buttonEndPoint = 460;
                }
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5f];
                [self.continueButton setFrame:CGRectMake(self.continueButton.frame.origin.x, buttonEndPoint, self.continueButton.frame.size.width, self.continueButton.frame.size.height)];
                [UIView commitAnimations];
            } else {
                if (self.iPhone4S) {
                    buttonEndPoint = 310;
                } else if (self.iPhone5) {
                    buttonEndPoint = 315;
                } else if (self.iPhone6) {
                    buttonEndPoint = 350;
                } else if (self.iPhone6Plus) {
                    buttonEndPoint = 395;
                } else if (self.iPad) {
                    buttonEndPoint = 564;
                }
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5f];
                [self.continueButton setFrame:CGRectMake(self.continueButton.frame.origin.x, buttonEndPoint, self.continueButton.frame.size.width, self.continueButton.frame.size.height)];
                [UIView commitAnimations];
            }
        }
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateLayoutForNewOrientation: toInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
- (IBAction)userNameEntered:(UITextField *)sender {
    if (([self.nameTextField.text length]) > 0) {
        self.continueButton.enabled = YES;
    } else {
        self.continueButton.enabled = NO;
    }
    
}

@end
