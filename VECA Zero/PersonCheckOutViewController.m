//
//  PersonCheckOutViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 10/3/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "PersonCheckOutViewController.h"
#import "DataModel.h"

@interface PersonCheckOutViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *injuredPicker;
@property (weak, nonatomic) IBOutlet UILabel *descibeIncidentLabel;
@property (weak, nonatomic) IBOutlet UITextField *superVisorTextField;
@property (weak, nonatomic) IBOutlet SignatureView *signatureView;
@property (weak, nonatomic) IBOutlet UITextView *incidentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *supervisorBGImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation PersonCheckOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.checkOutSignature.layer setCornerRadius:5];
    [self.checkOutSignature setLineWidth:2.0];
    self.checkOutSignature.foregroundLineColor = [UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1.000];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    if (_person != nil) {
        self.signatureView.image = _person.checkOutSignature;
    }
    
    self.title = _person.fullName;
    _person.isInjured = NO;
    _incidentTextView.hidden = YES;
    _descibeIncidentLabel.hidden = YES;
    _supervisorBGImage.hidden = YES;
    _superVisorTextField.hidden = YES;
    
    self.doneButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)injuredPicked:(UISegmentedControl *)sender {
    if ([sender selectedSegmentIndex] == 0) {
        _person.isInjured = YES;
        _incidentTextView.hidden = NO;
        _descibeIncidentLabel.hidden = NO;
        _supervisorBGImage.hidden = NO;
        _superVisorTextField.hidden = NO;
        self.doneButton.enabled = YES;
    } else if ([sender selectedSegmentIndex] == 1) {
        _person.isInjured = NO;
        _incidentTextView.hidden = YES;
        _descibeIncidentLabel.hidden = YES;
        _supervisorBGImage.hidden = YES;
        _superVisorTextField.hidden = YES;
        self.doneButton.enabled = YES;
    }
}


- (IBAction)doneButton:(UIBarButtonItem *)sender {
    _person.supervisor = _superVisorTextField.text;
    _person.checkOutSignature = _signatureView.signatureImage;
    _person.incidentDescription = _incidentTextView.text;
    
    [self dismissViewControllerAnimated:YES completion:nil];    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
