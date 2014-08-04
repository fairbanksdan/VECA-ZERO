//
//  HomeViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "HomeViewController.h"
#import "NewTaskViewController.h"

@interface HomeViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *EmailTextField;
@property (strong,nonatomic) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UITextField *NameTextField;
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
    
    self.textFields = @[self.EmailTextField, self.NameTextField];
    
    UITapGestureRecognizer *tapOutside = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.scrollView addGestureRecognizer:tapOutside];
    
    UIColor *color = [UIColor whiteColor];
    
    self.EmailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.NameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: color}];
    // Do any additional setup after loading the view.
    
//    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
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

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    if ([segue.identifier isEqualToString:@"New Task"]) {
//        UINavigationController *navigationController = segue.destinationViewController;
//        NewTaskViewController *controller = (NewTaskViewController *)navigationController;
//        controller.delegate = self;
//    }
//    
//}

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
