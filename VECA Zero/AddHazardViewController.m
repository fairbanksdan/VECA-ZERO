//
//  HazardViewController.m
//  VECA Zero
//
//  Created by Dan Fairbanks on 10/16/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "AddHazardViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Task.h"
#import "Job.h"
#import "Hazard.h"
#import "DataModel.h"

@interface AddHazardViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *hazardNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *solutionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *hazardImageView;
@property (strong,nonatomic) UIActionSheet *myActionSheet;

@end

@implementation AddHazardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.hazardNameTextField action:@selector(resignFirstResponder)];
//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    toolbar.items = [NSArray arrayWithObject:barButton];
//    
//    self.hazardNameTextField.inputAccessoryView = toolbar;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self.view addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.hazardNameTextField resignFirstResponder];
    [self.solutionTextView resignFirstResponder];
}

- (IBAction)cancel {
    [self.delegate AddHazardViewControllerDidCancel:self];
}

- (IBAction)doneButton:(UIBarButtonItem *)sender {
    Hazard *hazard = [Hazard new];
    hazard.hazardName = self.hazardNameTextField.text;
    hazard.solution = self.solutionTextView.text;
    hazard.checked = NO;
    hazard.solutionChecked = NO;
    hazard.hazardImage = self.hazardImageView.image;
    [self.delegate AddHazardViewController:self didFinishAddingHazard:hazard];
}

- (IBAction)findPicture:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.myActionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:@"Take Photo",@"Choose Photo", nil];
        
    }
    
    else {
        
        self.myActionSheet  = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:@"Choose Photo", nil];
    }
    
    
    
    
    [self.myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Photo"]) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose Photo" ]) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    } else {
        
        return;
        
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.hazardImageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    _hazard.hazardImage = editedImage;

//    self.selectedPerson.headShot = editedImage;
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Completed");
        
        ALAssetsLibrary *assetsLibrary = [ALAssetsLibrary new];
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
            [assetsLibrary writeImageToSavedPhotosAlbum:editedImage.CGImage
                                            orientation:ALAssetOrientationUp
                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                            if (error) {
                                                NSLog(@"Error Saving Image: %@", error.localizedDescription);
                                            }
                                        }];
        } else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Save Photo"
                                                                message:@"Denied access without authorization"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            
        } else {
            NSLog(@"Authorization Not Determined");
        }
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.hazardNameTextField resignFirstResponder];
//    [self.solutionTextView resignFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
//    [self.hazardNameTextField resignFirstResponder];
    [self.solutionTextView resignFirstResponder];
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
