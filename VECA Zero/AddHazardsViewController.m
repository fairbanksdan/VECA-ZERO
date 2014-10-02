//
//  AddHazardsViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "AddHazardsViewController.h"
#import "Hazard.h"
#import "Job.h"
#import "Task.h"
#import "HazardTableViewCell.h"

@interface AddHazardsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation AddHazardsViewController
{
    NSMutableArray *_localHazardsArray;
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
    
    _localHazardsArray = [[NSMutableArray alloc] initWithCapacity:20];
    
//    Hazard *hazard = [Hazard new];
//    
//    hazard.hazardName = @"Ladder";
//    hazard.solution = @"Do not go above the second to top rung of ladder";
//    [self.task.hazardArray addObject:hazard];
    
//    hazard.hazardName = @"Hole in Ground";
//    hazard.solution = @"Avoid the Hole.";
//    [_hazards addObject:hazard];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < ([_localHazardsArray count]+ 1)) {
        if (indexPath.row % 2) {
            return 88;
        } else {
            return 44;
        }
    } else {
        return 44;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_localHazardsArray count] + 2;
    [tableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < ([_localHazardsArray count] + 1)) {
        return 2;
//        return [_hazards count] * 2;
//        NSLog(@"hazards count is: %ul", [_hazards count]);
    } else {
    return 1;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Complete this page at task location";
    } else {
        return @"";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *CellIdentifier = @"HazardCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    if (indexPath.section < ([_localHazardsArray count]+ 1)) {
        if (indexPath.row % 2) {
            NSString *CellIdentifier = @"SolutionCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            return cell;
            
        } else {
            
                
                NSString *CellIdentifier = @"HazardCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    
                    
                    
                    
            }
            self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, 280, 30)];
            
            [self.textField setBorderStyle:UITextBorderStyleNone];
            self.textField.tag = indexPath.section;
            self.textField.placeholder = @"Hazard";
            NSLog(@"Hazard number is: %lu", self.textField.tag);
            
            
            [cell addSubview:self.textField];
            
            return cell;
            
        }
    } else {
        NSString *CellIdentifier = @"AddNewHazardCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        return cell;
    }
    
    self.textField = (UITextField*)[self.view viewWithTag:indexPath.section];
    NSString* textString = self.textField.text;
    
    Hazard *hazard = [Hazard new];
    hazard.hazardName = textString;
    NSLog(@"Hazard Name from Cell is %@", hazard.hazardName);


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ([_localHazardsArray count]+ 1)) {
        self.textField = (UITextField*)[self.view viewWithTag:indexPath.section];
        NSString* textString = self.textField.text;

        Hazard *hazard = [Hazard new];
        hazard.hazardName = textString;
//        NSLog(@"Hazard Name from Cell is %@", hazard.hazardName);
//        if (indexPath.section == [_localHazardsArray count]) {
//            
//            if (indexPath.row == 0) {
//                hazard.hazardName == ;
//            }
//            
//        }
        [_localHazardsArray addObject:hazard];
        
        [self.delegate AddHazardsViewController:self didFinishAddingItem:hazard];
        NSLog(@"Hazard Array Count is: %lu", [_localHazardsArray count]);
        [tableView reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleNone;
    } else if (indexPath.section == ([_localHazardsArray count]+ 1)){
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_localHazardsArray removeObjectAtIndex:indexPath.row];
        //    NSArray *indexPaths = @[indexPath];
        //    [tableView deleteRowsAtIndexPaths:indexPaths
        //                     withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

//- (IBAction)hazardTFChanged:(UITextField *)sender {
//    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
//    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
//    Hazard *hazard = [Hazard new];
//    hazard =
//    hazard.hazardName =
//}


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    //Replace the string manually in the textbox
//    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    //perform any logic here now that you are sure the textbox text has changed
//    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
//    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
//    [self didChangeTextInTextField:textField];
//    return NO; //this make iOS not to perform any action
//}



@end
