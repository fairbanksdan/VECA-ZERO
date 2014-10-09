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

@end

@implementation PersonCheckOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.checkOutSignature.layer setCornerRadius:5];
    [self.checkOutSignature setLineWidth:2.0];
    self.checkOutSignature.foregroundLineColor = [UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1.000];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.title = _person.fullName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
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
