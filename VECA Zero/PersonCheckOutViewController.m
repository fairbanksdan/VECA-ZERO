//
//  PersonCheckOutViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 10/3/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "PersonCheckOutViewController.h"
#import "SignOutViewController.h"
#import "DataModel.h"
#import <QuartzCore/QuartzCore.h>

@interface PersonCheckOutViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *injuredPicker;
@property (weak, nonatomic) IBOutlet UILabel *descibeIncidentLabel;
@property (weak, nonatomic) IBOutlet UITextField *superVisorTextField;
@property (weak, nonatomic) IBOutlet SignatureView *signatureView;
@property (weak, nonatomic) IBOutlet UITextView *incidentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *supervisorBGImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addSignatureButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PersonCheckOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Signature" style:UIBarButtonItemStylePlain target:nil action:@selector(addSignature:)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObject:barButton];
    
    self.incidentTextView.inputAccessoryView = toolbar;
    self.superVisorTextField.inputAccessoryView = toolbar;
    
    [self.checkOutSignature.layer setCornerRadius:5];
    [self.checkOutSignature setLineWidth:2.0];
    self.checkOutSignature.foregroundLineColor = [UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1.000];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.title = _person.fullName;
    
    _incidentTextView.hidden = YES;
    _descibeIncidentLabel.hidden = YES;
    _supervisorBGImage.hidden = YES;
    _superVisorTextField.hidden = YES;
    
    if (_person != nil) {
        self.signatureView.image = _person.checkOutSignature;
        if (_person.checkOutSignature == nil) {
            self.addSignatureButton.title = @"Add Signature";
            self.addSignatureButton.enabled = YES;
            self.doneButton.enabled = NO;
        } else {
            self.addSignatureButton.title = @"Edit Signature";
            self.addSignatureButton.enabled = YES;
            self.doneButton.enabled = YES;
            
            
        }
        
        if (_person.isInjured != NO && _person.isInjured != YES) {
        
        } else {
            if (_person.isInjured == YES) {
                _injuredPicker.selectedSegmentIndex = 0;
                self.incidentTextView.hidden = NO;
                self.superVisorTextField.hidden = NO;
                self.supervisorBGImage.hidden = NO;
                self.incidentTextView.text = _person.incidentDescription;
                self.superVisorTextField.text = _person.supervisor;
            } else if (_person.isInjured == NO) {
                _injuredPicker.selectedSegmentIndex = 1;
            }
        }
    }
    
//    _person.isInjured = NO;
    
    _incidentTextView.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0);
    
//    self.doneButton.enabled = NO;
    self.signView.hidden = YES;
    [self.signView.layer setCornerRadius:5];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _scrollView.frame = CGRectMake(0, 0, 320, 568);
    _scrollView.contentSize = CGSizeMake(320, 650);
    [_scrollView setScrollEnabled:YES];
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
    }
}

- (IBAction)addSignature:(UIBarButtonItem *)sender {
    
    [self.incidentTextView resignFirstResponder];
    [self.superVisorTextField resignFirstResponder];
    
    if ([self.addSignatureButton.title isEqualToString:@"Add Signature"]) {
        self.addSignatureButton.title = @"Close Signature View";
//        self.doneButton.enabled = YES;
        self.signView.hidden = NO;
        [_scrollView setScrollEnabled:NO];
    } else if ([self.addSignatureButton.title isEqualToString:@"Close Signature View"]) {
        if (_person == nil) {
            self.addSignatureButton.title = @"Add Signature";
        } else if (_person != nil) {
            self.addSignatureButton.title = @"Edit Signature";
        }
        self.signView.hidden = YES;
        [_scrollView setScrollEnabled:YES];
    } else if ([self.addSignatureButton.title isEqualToString:@"Edit Signature"]) {
        self.addSignatureButton.title = @"Close Signature View";
        self.doneButton.enabled = YES;
        self.signView.hidden = NO;
        [_scrollView setScrollEnabled:NO];
    }
}

- (IBAction)doneButton:(UIBarButtonItem *)sender {
    _person.supervisor = _superVisorTextField.text;
    _person.checkOutSignature = _signatureView.signatureImage;
    _person.incidentDescription = _incidentTextView.text;
    [self.delegate UpdateTableView];
    
}
- (IBAction)clearButton:(UIButton *)sender {
    [self.signatureView clear];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.incidentTextView resignFirstResponder];
    [self.superVisorTextField resignFirstResponder];
}

@end
