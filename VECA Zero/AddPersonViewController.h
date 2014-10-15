//
//  AddPersonViewController.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "SignatureView.h"
#import "Job.h"
#import "Task.h"

@class AddPersonViewController;
@class Person;

@protocol AddPersonViewControllerDelegate <NSObject>

- (void)AddPersonViewControllerDidCancel:(AddPersonViewController *)controller;

- (void)AddPersonViewController:(AddPersonViewController *)controller
         didFinishAddingItem:(Person *)person;

- (void)AddPersonViewController:(AddPersonViewController *)controller
        didFinishEditingItem:(Person *)person;

@end


@interface AddPersonViewController : UIViewController

- (IBAction)Cancel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIColor *navBarColor;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) UIImage *signature;
@property (weak, nonatomic) IBOutlet SignatureView *signatureView;
@property BOOL areHazardsChecked;

@property (strong, nonatomic) Person *personToEdit;
@property (strong, nonatomic) Job *job;
@property (strong, nonatomic) Task *task;

@property (nonatomic, weak) id <AddPersonViewControllerDelegate> delegate;

@end
