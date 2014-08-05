//
//  AddJobViewController.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddJobViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIColor *navBarColor;
@property (weak, nonatomic) IBOutlet UITextField *jobNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *foremanNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *foremanEmailTextField;

@end
