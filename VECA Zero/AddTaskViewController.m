//
//  AddTaskViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 9/30/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "AddTaskViewController.h"
#import "Task.h"

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel {
    [self.delegate AddTaskViewControllerDidCancel:self];
}

- (IBAction)next {
    Task *task = [Task new];
    task.taskName = self.taskNameTextField.text;
    task.specificTaskLocation = self.specificTaskLocationTextField.text;
    task.PrimaryEvacuation = self.PrimaryEvacTextField.text;
    task.SecondaryEvacuation = self.SecondaryEvacTextField.text;
    NSLog(@"Next Button Pressed");
    
    [self.delegate AddTaskViewController:self didFinishAddingItem:task];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewHazards"]) {
        [self saveTask];
    }
}

-(void)saveTask {
    Task *task = [Task new];
    task.taskName = self.taskNameTextField.text;
    task.specificTaskLocation = self.specificTaskLocationTextField.text;
    task.PrimaryEvacuation = self.PrimaryEvacTextField.text;
    task.SecondaryEvacuation = self.SecondaryEvacTextField.text;
    NSLog(@"Next Button Pressed");
    
    [self.delegate AddTaskViewController:self didFinishAddingItem:task];
}

//- (void)saveTask {
//    
//}

#pragma mark - Table view data source

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}



@end
