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
#import <MessageUI/MessageUI.h>

@interface PersonCheckOutViewController () <UITextViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIToolbarDelegate>
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
{
    UIBarButtonItem *_barButton;
    UIBarButtonItem *_flexibleSpace;
    UITapGestureRecognizer *_tap;
    UITapGestureRecognizer *_pan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _barButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Signature" style:UIBarButtonItemStylePlain target:nil action:@selector(addSignature:)];
    _flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects:_flexibleSpace, _barButton, _flexibleSpace, nil];
    
    self.incidentTextView.inputAccessoryView = toolbar;
    self.superVisorTextField.inputAccessoryView = toolbar;
    
    [self.checkOutSignature.layer setCornerRadius:5];
    [self.checkOutSignature setLineWidth:2.0];
    self.checkOutSignature.foregroundLineColor = [UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1.000];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.incidentTextView.delegate = self;
    
    self.title = _person.fullName;
    
    _incidentTextView.hidden = YES;
    _descibeIncidentLabel.hidden = YES;
    _supervisorBGImage.hidden = YES;
    _superVisorTextField.hidden = YES;
//    _injuredPicker.selectedSegmentIndex = 1;
    
    
    if (_person != nil) {
        self.signatureView.image = _person.checkOutSignature;
        if (_person.checkOutSignature == nil) {
            self.addSignatureButton.title = @"Add Signature";
            self.addSignatureButton.enabled = YES;
            self.doneButton.enabled = NO;
            self.addSignatureButton.enabled = NO;
            _barButton.enabled = NO;
        } else {
            self.addSignatureButton.title = @"Edit Signature";
            self.addSignatureButton.enabled = YES;
            self.doneButton.enabled = YES;
            self.addSignatureButton.enabled = YES;
            _barButton.enabled = YES;
        }
            
        if (_person.isInjured == YES) {
            _injuredPicker.selectedSegmentIndex = 0;
            self.incidentTextView.hidden = NO;
            self.superVisorTextField.hidden = NO;
            self.supervisorBGImage.hidden = NO;
            self.descibeIncidentLabel.hidden = NO;
            self.incidentTextView.text = _person.incidentDescription;
            self.superVisorTextField.text = _person.supervisor;
        } else if (_person.isInjured == NO) {
            _injuredPicker.selectedSegmentIndex = 1;
            self.addSignatureButton.enabled = YES;
            _barButton.enabled = YES;
        }
    }
    
//    _person.isInjured = NO;
    
    _incidentTextView.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0);
    
//    self.doneButton.enabled = NO;
    
    self.signView.hidden = YES;
    [self.signView.layer setCornerRadius:5];
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:_tap];
    [self.view addGestureRecognizer:_pan];
}

-(void)dismissKeyboard {
    
    [self.incidentTextView resignFirstResponder];
    [self.superVisorTextField resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _scrollView.frame = CGRectMake(0, 0, 320, 568);
    _scrollView.contentSize = CGSizeMake(320, 690);
    [_scrollView setScrollEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
    _person.isInjured = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)injuredPicked:(UISegmentedControl *)sender {
    if ([sender selectedSegmentIndex] == 0) {
        _incidentTextView.hidden = NO;
        _descibeIncidentLabel.hidden = NO;
        _supervisorBGImage.hidden = NO;
        _superVisorTextField.hidden = NO;
        self.addSignatureButton.enabled = NO;
        _barButton.enabled = NO;
        
    } else if ([sender selectedSegmentIndex] == 1) {
        _incidentTextView.hidden = YES;
        _descibeIncidentLabel.hidden = YES;
        _supervisorBGImage.hidden = YES;
        _superVisorTextField.hidden = YES;
        self.addSignatureButton.enabled = YES;
        _barButton.enabled = YES;
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
        if (_injuredPicker.selectedSegmentIndex == 0 && self.incidentTextView.text.length > 0  && self.superVisorTextField.text.length > 0) {
            self.doneButton.enabled = YES;
        } else if (_injuredPicker.selectedSegmentIndex == 1) {
            self.doneButton.enabled = YES;
        }
        [self.view removeGestureRecognizer:_tap];
        [self.view removeGestureRecognizer:_pan];
    } else if ([self.addSignatureButton.title isEqualToString:@"Close Signature View"]) {
        if (_person == nil) {
            self.addSignatureButton.title = @"Add Signature";
        } else if (_person != nil) {
            self.addSignatureButton.title = @"Edit Signature";
        }
        self.signView.hidden = YES;
        [_scrollView setScrollEnabled:YES];
        [self.view addGestureRecognizer:_tap];
        [self.view addGestureRecognizer:_pan];
    } else if ([self.addSignatureButton.title isEqualToString:@"Edit Signature"]) {
        self.addSignatureButton.title = @"Close Signature View";
        self.doneButton.enabled = YES;
        self.signView.hidden = NO;
        [_scrollView setScrollEnabled:NO];
        if (_injuredPicker.selectedSegmentIndex == 0 && self.incidentTextView.text.length > 0  && self.superVisorTextField.text.length > 0) {
            self.doneButton.enabled = YES;
        } else if (_injuredPicker.selectedSegmentIndex == 1) {
            self.doneButton.enabled = YES;
        }
        [self.view removeGestureRecognizer:_tap];
        [self.view removeGestureRecognizer:_pan];
    }
}

-(void)textViewDidChange:(UITextView *)textView {
    if (self.incidentTextView.text.length > 0) {
        if (self.superVisorTextField.text.length > 0) {
            self.addSignatureButton.enabled = YES;
            _barButton.enabled = YES;
        }
    } else if (self.incidentTextView.text.length < 1) {
        self.addSignatureButton.enabled = NO;
        _barButton.enabled = NO;
    }
}

- (IBAction)supervisorTextChanged:(UITextField *)sender {
    if (self.superVisorTextField.text.length > 0) {
        if (self.incidentTextView.text.length > 0) {
        self.addSignatureButton.enabled = YES;
        _barButton.enabled = YES;
        }
    } else if (self.superVisorTextField.text.length < 1) {
        self.addSignatureButton.enabled = NO;
        _barButton.enabled = NO;
    }
//    if ((_person.checkOutSignature != nil) && (self.incidentTextView.text.length > 0) && (self.superVisorTextField.text.length > 0)) {
//        self.doneButton.enabled = YES;
//    } else {
//        self.doneButton.enabled = NO;
//    }
}

- (IBAction)doneButton:(UIBarButtonItem *)sender {
    if (_injuredPicker.selectedSegmentIndex == 1) {
        _person.isInjured = NO;
        _person.incidentDescription = nil;
        _person.checkOutSignature = _signatureView.signatureImage;
        _person.supervisor = nil;
        [self.delegate UpdateTableView];
    } else {
        _person.isInjured = YES;
        _person.supervisor = _superVisorTextField.text;
        _person.checkOutSignature = _signatureView.signatureImage;
        _person.incidentDescription = _incidentTextView.text;
        [self textMessage:(id)sender];
    }
    
}

- (IBAction)clearButton:(UIButton *)sender {
    [self.signatureView clear];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.incidentTextView resignFirstResponder];
    [self.superVisorTextField resignFirstResponder];
}

- (IBAction)textMessage:(id)sender {
    if ([MFMessageComposeViewController canSendText]) {
        [self displayMessageComposerSheet];
    } else {
        NSLog(@"Device is unable to send email in its current state.");
    }
}

- (void)displayMessageComposerSheet {
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    
    
    NSArray *toRecipients = [[NSArray alloc] initWithObjects:@"206-234-2238", @"509-431-5561", nil];
    
    [picker setRecipients:toRecipients];
    
    NSString *jobName = [[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] jobName];

    NSString *personName = _person.fullName;
    NSString *incidentDesc = _person.incidentDescription;
    NSString *superVName = _person.supervisor;
    NSString *messageContent = [NSString stringWithFormat:@"%@ got injured today at %@. Description of incident: %@. The supervisor is: %@", personName, jobName, incidentDesc, superVName];
    
    [picker setBody:messageContent];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    
    {
        case MessageComposeResultCancelled: {
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        }
            
        case MessageComposeResultFailed: {
            
            break;
        }
            
        case MessageComposeResultSent: {
            [self.delegate UpdateTableView];
            [self dismissViewControllerAnimated:YES completion:NULL];
            [self dismissPersonCheckOutViewController];
            break;
        }
    }
    
}

- (void)dismissPersonCheckOutViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
