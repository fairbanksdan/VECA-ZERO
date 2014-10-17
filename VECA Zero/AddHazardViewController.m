//
//  HazardViewController.m
//  VECA Zero
//
//  Created by Dan Fairbanks on 10/16/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "AddHazardViewController.h"
#import "Task.h"
#import "Job.h"
#import "Hazard.h"
#import "DataModel.h"

@interface AddHazardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *hazardNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *solutionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *hazardImageView;

@end

@implementation AddHazardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel {
    [self.delegate AddHazardViewControllerDidCancel:self];
}

- (IBAction)doneButton:(UIBarButtonItem *)sender {
    Hazard *hazard = [Hazard new];
    hazard.hazardName = self.hazardNameTextField.text;
    hazard.solution = self.solutionTextView.text;
    [self.delegate AddHazardViewController:self didFinishAddingHazard:hazard];
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
