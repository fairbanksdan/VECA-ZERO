//
//  SignInViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "SignInViewController.h"
#import "Person.h"
#import "MidTaskViewController.h"

@interface SignInViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SignInViewController
{
    NSMutableArray *_persons; //creates a mutable Array with the variable "_items"
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory]
            stringByAppendingPathComponent:@"VECA Zero.plist"];
}

- (void)savePersons
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:_persons forKey:@"Persons"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadPersons
{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                         initForReadingWithData:data];
        _persons = [unarchiver decodeObjectForKey:@"Persons"];
        
        [unarchiver finishDecoding];
    } else {
        _persons = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self loadPersons];
    }
    return self;
}
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Documents folder is %@", [self documentsDirectory]);
    NSLog(@"Data file path is %@", [self dataFilePath]);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
//    self.personArray = [NSMutableArray new];
//    
//    Person *person1 = [Person new];
//    person1.fullName = @"Dan Fairbanks";
//    
//    [self.personArray addObject:person1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)configureTextForCell:(UITableViewCell *)cell withPersonName:(Person *)person {
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = person.fullName;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_persons count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"MidTask" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"PersonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    Person *person = _persons[indexPath.row];
    [self configureTextForCell:cell withPersonName:person];
    
    return cell;
    
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
//    }
//    if (indexPath.row == 0) {
//        Person *person = [self.personArray objectAtIndex:indexPath.row];
//        cell.textLabel.text = person.fullName;
//    } else {
//        cell.textLabel.text = @"Add New Person";
//    }
//    
//    return cell;
}

- (void)AddPersonViewController:(AddPersonViewController *)controller didFinishAddingItem:(Person *)person {
    NSInteger newRowIndex = [_persons count];
    [_persons insertObject:person atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath
                              indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [self savePersons];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddPersonViewController:(AddPersonViewController *)controller didFinishEditingItem:(Person *)person {
    NSInteger index = [_persons indexOfObject:person];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                inSection:0];
    UITableViewCell *cell = [self.tableView
                             cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withPersonName:person];
    
    [self savePersons];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddPersonViewControllerDidCancel:(AddPersonViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
    
    Person *myPerson;
    
    if ([segue.identifier isEqualToString:@"AddPerson"]) {
        UINavigationController *navigationController =
        segue.destinationViewController;
        AddPersonViewController *controller = (AddPersonViewController *)navigationController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"EditPerson]"]) {
        UINavigationController *navigationController =
        segue.destinationViewController;
        AddPersonViewController *controller = (AddPersonViewController *)navigationController;
        
        NSIndexPath *indexPath = [self.tableView
                                  indexPathForCell:sender];
        controller.personToEdit = [Person new];
        controller.personToEdit = _persons[indexPath.row];
        controller.fullNameTextField.text = controller.personToEdit.fullName;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"MidTask"]) {
        MidTaskViewController *destViewController = segue.destinationViewController;
        destViewController.person = sender;
        myPerson = [_persons objectAtIndex:myIndexPath.row];
        destViewController.person = myPerson;
    }
    
    
    
    
}



@end
