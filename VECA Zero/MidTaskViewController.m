//
//  MidTaskViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "MidTaskViewController.h"
#import "SignOutViewController.h"
#import "DataModel.h"

@interface MidTaskViewController ()

@end

@implementation MidTaskViewController
{
    UIAlertController *_noteToUser;
}

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
    [self.checkOutButton.layer setCornerRadius:5];

    
}

- (void)viewWillAppear:(BOOL)animated {
    _noteToUser = [UIAlertController alertControllerWithTitle:@"Note to User" message:@"\nGo perform the task.\n\nReturn to this page when the task is complete to check out of the task.\n\nThis alert will not be shown again." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Dismiss"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [_noteToUser dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [_noteToUser addAction:cancel];
    
    if (DataModel.myDataModel.firstCheckOut == YES) {
        [self presentViewController:_noteToUser animated:YES completion:nil];
        DataModel.myDataModel.firstCheckOut = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)AddPersonMidTaskButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SignOut"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SignOutViewController *controller = (SignOutViewController *)navigationController.topViewController;
        controller.job = _job;
        controller.task = _task;
        controller.task.personArray = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray];
        
    }
}

@end
