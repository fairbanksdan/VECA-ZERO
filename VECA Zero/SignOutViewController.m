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

@interface SignOutViewController () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation SignOutViewController
{
    Person *_person;
    UIAlertController *_verificationAlert;
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

- (void)configureCheckmarkForCell:(UITableViewCell *)cell
                       withPerson:(Person *)person
{
    UILabel *label = (UILabel *)[cell viewWithTag:2000];
    
    label.textColor = [UIColor blueColor];
    
    if (person.checkOutSignature != nil) {
        label.text = @"√";
    } else {
        label.text = @"";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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

- (IBAction)submitButtonPressed:(id)sender {
    [self showAlert:(id)sender];
}

- (IBAction)email:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        [self displayMailComposerSheet];
    } else {
        NSLog(@"Device is unable to send email in its current state.");
    }
}

- (IBAction)showAlert:(id)sender {
    _verificationAlert = [UIAlertController alertControllerWithTitle:@"Verify" message:@"\nHave all of the users who checked into this task checked out of this task?\n\nUsers who have checked out will have a checkmark next to their name. If someone is not available to check out of the task you may select 'Yes' to submit the task without the person being checked out." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [_verificationAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    UIAlertAction *notSure = [UIAlertAction
                             actionWithTitle:@"Not Sure"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [_verificationAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    UIAlertAction *submit = [UIAlertAction
                             actionWithTitle:@"Yes"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self email:(id)sender];
                             }];
    
    [_verificationAlert addAction:submit];
    [_verificationAlert addAction:cancel];
    [_verificationAlert addAction:notSure];
    
    [self presentViewController:_verificationAlert animated:YES completion:nil];
}

- (void)displayMailComposerSheet {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"bryan.morrison@veca.com"];

    [picker setToRecipients:toRecipients];

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

    for (int i = 0; i < [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] count]; i++) {
        [hazardsArray addObject:[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:i]];
    }
    
    for (int i = 0; i < [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] count]; i++) {
        
        [personsArray addObject:[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:i]];
    }

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
    
    [picker setSubject:[NSString stringWithFormat:@"VECA JSA for %@", jobName]];

    [picker setMessageBody:finalMessage isHTML:NO];

    // Attach an image to the email

    NSMutableArray *checkInSignaturesArray = [[NSMutableArray alloc] initWithCapacity:20];
    NSMutableArray *checkOutSignaturesArray = [[NSMutableArray alloc] initWithCapacity:20];
    NSMutableArray *hazardImageArray = [[NSMutableArray alloc] initWithCapacity:20];

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
    
    for (int i = 0; i < [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] count]; i++) {
        if ([[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:i] hazardImage] != nil) {
            [hazardImageArray addObject:[[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:i] hazardImage]];
        }
    }
    
    if (checkOutSignaturesArray.count > 0) {
        for (int i = 0; i < [checkOutSignaturesArray count]; i++) {
            UIImage *signOutImage = [checkOutSignaturesArray objectAtIndex:i];
            NSData *mysignOutImage = [NSData dataWithData:UIImagePNGRepresentation(signOutImage)];
            [picker addAttachmentData:mysignOutImage mimeType:@"image/png" fileName:[NSString stringWithFormat:@"Sign Out Signature of %@ on %@", ([[personsArray objectAtIndex:i] fullName]), taskDate]];
        }
    }
    
    if (hazardImageArray.count > 0) {
        for (int i = 0; i < [hazardImageArray count]; i++) {
            UIImage *hazardImage = [hazardImageArray objectAtIndex:i];
            NSData *myHazardImage = [NSData dataWithData:UIImagePNGRepresentation(hazardImage)];
            [picker addAttachmentData:myHazardImage mimeType:@"image/png" fileName:[NSString stringWithFormat:@"Hazard Named %@ on %@", ([[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:i] hazardName]), taskDate]];
        }
    }
    
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
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
            DataModel.myDataModel.mainUser.checkInSignature = nil;
            DataModel.myDataModel.mainUser.checkOutSignature = nil;
            DataModel.myDataModel.mainUser.isInjured = nil;
            DataModel.myDataModel.mainUser.incidentDescription = nil;
            DataModel.myDataModel.mainUser.supervisor = nil;
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



- (void)UpdateTableView {
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
