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

@interface SignOutViewController () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate>
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

//- (IBAction)Submit:(UIBarButtonItem *)sender {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//
//    
//    NSString *jobName = [[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] jobName];
//    NSString *jobNumber = [[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] jobNumber];
//    NSString *taskName = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] taskName];
//    NSString *taskLocation = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] specificTaskLocation];
//    NSString *primaryEvacuation = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] PrimaryEvacuation];
//    NSString *secondaryEvacuation = [[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] SecondaryEvacuation];
//    NSString *taskDate = [formatter stringFromDate:[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] date]];
//    
//    NSString *hazardName = [[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:0] hazardName];
//    NSString *hazardSolution = [[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] hazardArray] objectAtIndex:0] solution];
//    NSString *firstPerson = [[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:0] fullName];
//    
//    UIImage *checkInSignature = [[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:0] checkInSignature];
//    
//    
//    NSString *message = [NSString stringWithFormat:@"Job Name: %@ \nJob Number: %@\nTask Name: %@\nTask Location: %@\nTask Date: %@\nPrimary Evacuation Location: %@\nSecondary Evacuation Location: %@\nHazard Name: %@\nHazard Solution: %@\nFirst Person: %@", jobName, jobNumber, taskName, taskLocation, taskDate, primaryEvacuation, secondaryEvacuation, hazardName, hazardSolution, firstPerson];
//    
//    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[message, checkInSignature] applicationActivities:nil];;
//    activityViewController.excludedActivityTypes = @[UIActivityTypePrint,
//                                                     UIActivityTypeCopyToPasteboard,
//                                                     UIActivityTypeAssignToContact,
//                                                     UIActivityTypeSaveToCameraRoll,
//                                                     UIActivityTypeAddToReadingList,
//                                                     UIActivityTypePostToFlickr,
//                                                     UIActivityTypePostToVimeo,
//                                                     UIActivityTypePostToFacebook,
//                                                     UIActivityTypePostToTwitter,
//                                                     UIActivityTypeMessage,
//                                                     UIActivityTypePostToTencentWeibo,
//                                                     UIActivityTypePostToWeibo];
//    
//    [self presentViewController:activityViewController animated:YES completion:nil];
//}

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
    
    for (int i = 0; i < (([hazardsArray count] /2)+1); i++) {
        NSString *newHazard = [[hazardsArray objectAtIndex:i] hazardName];
        NSString *newSolution = [[hazardsArray objectAtIndex:i] solution];
        hazardStrings = [hazardStrings stringByAppendingString:[NSString stringWithFormat:@"\nHazard %d: %@\nSolution %d: %@", i+1, newHazard, i+1, newSolution]];
        mailMessage = [message stringByAppendingString:hazardStrings];
        
    }

    for (int i = 0; i < [personsArray count]; i++) {
        NSString *newPerson = [[personsArray objectAtIndex:i] fullName];
        emailContent = [emailContent stringByAppendingString:[NSString stringWithFormat:@"\nPerson assigned to Task: %@", newPerson]];
        finalMessage = [mailMessage stringByAppendingString:emailContent];
    }

    [picker setMessageBody:finalMessage isHTML:NO];


    // Attach an image to the email

    NSMutableArray *signaturesArray = [[NSMutableArray alloc] initWithCapacity:20];

//        UIImage *checkInSignature = [[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:0] checkInSignature];

    for (int i = 0; i < [[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] count]; i++) {
        [signaturesArray addObject:[[[[[[DataModel.myDataModel.jobsArray objectAtIndex:_job.jobIndexPath] tasksForJobArray] objectAtIndex:_task.taskIndexPath] personArray] objectAtIndex:i] checkInSignature]];
    }

    for (int i = 0; i < [signaturesArray count]; i++) {
        UIImage *image = [signaturesArray objectAtIndex:i];
        NSData *myData = [NSData dataWithData:UIImagePNGRepresentation(image)];
        [picker addAttachmentData:myData mimeType:@"image/png" fileName:[NSString stringWithFormat:@"Sign In Signature of %@ on %@", ([[personsArray objectAtIndex:i] fullName]), taskDate]];
    }




    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
//    self.feedbackMsg.hidden = NO;
//    // Notifies users about errors associated with the interface
//    switch (result)
//    {
//        case MFMailComposeResultCancelled:
//            self.feedbackMsg.text = @"Result: Mail sending canceled";
//            break;
//        case MFMailComposeResultSaved:
//            self.feedbackMsg.text = @"Result: Mail saved";
//            break;
//        case MFMailComposeResultSent:
//            self.feedbackMsg.text = @"Result: Mail sent";
//            break;
//        case MFMailComposeResultFailed:
//            self.feedbackMsg.text = @"Result: Mail sending failed";
//            break;
//        default:
//            self.feedbackMsg.text = @"Result: Mail not sent";
//            break;
//    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
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
