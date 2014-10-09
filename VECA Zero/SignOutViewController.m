//
//  SignOutViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "SignOutViewController.h"
#import "DataModel.h"
#import "PersonCheckOutViewController.h"

@interface SignOutViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SignOutViewController

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
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:self completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"PersonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    cell.textLabel.text = [[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:indexPath.row] fullName];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"PersonCheckOut" sender:[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PersonCheckOut"]) {
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        UINavigationController *navigationController = segue.destinationViewController;
        PersonCheckOutViewController *controller = (PersonCheckOutViewController *)navigationController.topViewController;
        controller.job = _job;
        controller.task = _task;
        controller.person = [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:myIndexPath.row];
    
    
    }
}

- (IBAction)Submit:(UIBarButtonItem *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];

    
    NSString *jobName = [[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] jobName];
    NSString *jobNumber = [[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] jobNumber];
    NSString *taskName = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] taskName];
    NSString *taskDate = [formatter stringFromDate:[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] date]];
    NSString *hazardName = [[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:0] hazardName];
    NSString *hazardSolution = [[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:0] solution];
    
    
    NSString *message = [NSString stringWithFormat:@"Job Name: %@ \nJob Number: %@\nTask Name: %@\nTask Date: %@\nHazard Name: %@\nHazard Solution: %@", jobName, jobNumber, taskName, taskDate, hazardName, hazardSolution];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[message] applicationActivities:nil];;
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypeSaveToCameraRoll,
                                                     UIActivityTypeAddToReadingList,
                                                     UIActivityTypePostToFlickr,
                                                     UIActivityTypePostToVimeo,
                                                     UIActivityTypePostToFacebook,
                                                     UIActivityTypePostToTwitter,
                                                     UIActivityTypeMessage,
                                                     UIActivityTypePostToTencentWeibo,
                                                     UIActivityTypePostToWeibo];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
