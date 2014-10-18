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
#import <MessageUI/MessageUI.h>
#import "JobsViewController.h"

@interface SignOutViewController () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation SignOutViewController
{
    Person *_person;
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
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [self.submitButton.layer setCornerRadius:5];
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

        return @"Click on each person below to check them out of this task:";
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"PersonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    _person = [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = _person.fullName;
    
    [self configureCheckmarkForCell:cell withPerson:_person];
    
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
        controller.delegate = self;
        controller.job = _job;
        controller.task = _task;
        controller.person = [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:myIndexPath.row];
    
    
    } else if ([segue.identifier isEqualToString:@"BackToJobs"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        JobsViewController *controller = (JobsViewController *)navigationController.topViewController;
    }
}

- (IBAction)email:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        [self displayMailComposerSheet];
    } else {
        NSLog(@"Device is unable to send email in its current state.");
    }
}

- (void)displayMailComposerSheet {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"VECA JSA Test Email"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"dan.fairbanks@freshconsulting.com"];
//        NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//        NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];

    [picker setToRecipients:toRecipients];
//        [picker setCcRecipients:ccRecipients];
//        [picker setBccRecipients:bccRecipients];

    // Fill out the email body text

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];

    NSMutableArray *personsArray = [[NSMutableArray alloc] initWithCapacity:20];
    NSMutableArray *hazardsArray = [[NSMutableArray alloc] initWithCapacity:20];

    NSString *jobName = [[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] jobName];
    NSString *jobNumber = [[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] jobNumber];
    NSString *taskName = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] taskName];
    NSString *taskLocation = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] specificTaskLocation];
    NSString *primaryEvacuation = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] PrimaryEvacuation];
    NSString *secondaryEvacuation = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] SecondaryEvacuation];
    NSString *taskDate = [formatter stringFromDate:[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] date]];
//
//    NSString *hazardName = [[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:0] hazardName];
//    NSString *hazardSolution = [[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:0] solution];

    for (int i = 0; i < [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] count]; i++) {
        [hazardsArray addObject:[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:i]];
    }
    
    for (int i = 0; i < [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] count]; i++) {
        
        [personsArray addObject:[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:i]];
    }


//        NSString *firstPerson = [[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:0] fullName];
    NSString *emailContent = [NSString new];
    NSString *hazardStrings = [NSString new];
    NSString *mailMessage = [NSString new];
    NSString *finalMessage = [NSString new];

    NSString *message = [NSString stringWithFormat:@"Job Name: %@ \nJob Number: %@\nTask Name: %@\nTask Location: %@\nTask Date: %@\nPrimary Evacuation Location: %@\nSecondary Evacuation Location: %@", jobName, jobNumber, taskName, taskLocation, taskDate, primaryEvacuation, secondaryEvacuation];
    
    for (int i = 0; i < [hazardsArray count]; i++) {
        NSString *newHazard = [[hazardsArray objectAtIndex:i] hazardName];
        NSString *newSolution = [[hazardsArray objectAtIndex:i] solution];
        hazardStrings = [hazardStrings stringByAppendingString:[NSString stringWithFormat:@"\nHazard %d: %@\nSolution %d: %@", i+1, newHazard, i+1, newSolution]];
        mailMessage = [message stringByAppendingString:hazardStrings];
        
    }

    for (int i = 0; i < [personsArray count]; i++) {
        NSString *newPerson = [[personsArray objectAtIndex:i] fullName];
        NSString *isInjured = [NSString stringWithFormat:@"%@", [[personsArray objectAtIndex:i] isInjured] ? @"Yes" : @"No"];
        NSString *incidentDesc = [[personsArray objectAtIndex:i] incidentDescription];
        NSString *superVName = [[personsArray objectAtIndex:i] supervisor];
        emailContent = [emailContent stringByAppendingString:[NSString stringWithFormat:@"\nPerson assigned to Task: %@\nWas %@ involved in an injury, incident, or near miss?: %@\nIncident Description: %@\nSupervisor: %@", newPerson, newPerson, isInjured, incidentDesc, superVName]];
        finalMessage = [mailMessage stringByAppendingString:emailContent];
    }

    [picker setMessageBody:finalMessage isHTML:NO];


    // Attach an image to the email

    NSMutableArray *checkInSignaturesArray = [[NSMutableArray alloc] initWithCapacity:20];
    NSMutableArray *checkOutSignaturesArray = [[NSMutableArray alloc] initWithCapacity:20];

//        UIImage *checkInSignature = [[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:0] checkInSignature];

    for (int i = 0; i < [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] count]; i++) {
        [checkInSignaturesArray addObject:[[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:i] checkInSignature]];
        if ([[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:i] checkOutSignature] != nil) {
            [checkOutSignaturesArray addObject:[[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:i] checkOutSignature]];
        }
        
    }
    
    for (int i = 0; i < [checkInSignaturesArray count]; i++) {
        UIImage *signInImage = [checkInSignaturesArray objectAtIndex:i];
        NSData *mysignInImage = [NSData dataWithData:UIImagePNGRepresentation(signInImage)];
        [picker addAttachmentData:mysignInImage mimeType:@"image/png" fileName:[NSString stringWithFormat:@"Sign In Signature of %@ on %@", ([[personsArray objectAtIndex:i] fullName]), taskDate]];
    }
    
    if (checkOutSignaturesArray.count > 0) {
        for (int i = 0; i < [checkOutSignaturesArray count]; i++) {
            UIImage *signOutImage = [checkOutSignaturesArray objectAtIndex:i];
            NSData *mysignOutImage = [NSData dataWithData:UIImagePNGRepresentation(signOutImage)];
            [picker addAttachmentData:mysignOutImage mimeType:@"image/png" fileName:[NSString stringWithFormat:@"Sign Out Signature of %@ on %@", ([[personsArray objectAtIndex:i] fullName]), taskDate]];
        }
    }
    
    [self presentViewController:picker animated:YES completion:NULL];
    
//    if (picker.navigationBar. == MFMailComposeResultSent) {
//        [self performSegueWithIdentifier:@"BackToJobs" sender:self];
//    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
//    self.feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //self.feedbackMsg.text = @"Result: Mail sending canceled";
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        case MFMailComposeResultSaved:
//            self.feedbackMsg.text = @"Result: Mail saved";
            break;
        case MFMailComposeResultSent:
            [self dismissViewControllerAnimated:YES completion:NULL];
            [self performSegueWithIdentifier:@"BackToJobs" sender:self];
//            self.feedbackMsg.text = @"Result: Mail sent";
            break;
        case MFMailComposeResultFailed:
//            self.feedbackMsg.text = @"Result: Mail sending failed";
            break;
        default:
//            self.feedbackMsg.text = @"Result: Mail not sent";
            break;
    }
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell
                        withPerson:(Person *)person //methods for checking and unchecking a cell/row
{
    UILabel *label = (UILabel *)[cell viewWithTag:2000];
    
    label.textColor = [UIColor blueColor];
    
    if (person.checkOutSignature != nil) {
        label.text = @"√";
    } else {
        label.text = @"";
    }
}

//- (void)PersonCheckOutViewController:(PersonCheckOutViewController *)controller didCheckOutPerson:(Person *)person {
//    _person.checkOutSignature = person.checkOutSignature;
//    [self.tableView reloadData];
//    NSLog(@"Check triggered");
//    [self dismissViewControllerAnimated:YES completion:nil]; 
//}

- (void)UpdateTableView {
    [self.tableView reloadData];
    NSLog(@"Check triggered");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
