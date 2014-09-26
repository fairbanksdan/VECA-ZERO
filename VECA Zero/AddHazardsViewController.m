//
//  AddHazardsViewController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "AddHazardsViewController.h"
#import "Hazard.h"

@interface AddHazardsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation AddHazardsViewController
{
    NSMutableArray *_hazards;
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
    
    
    
    _hazards = [NSMutableArray new];
    
    Hazard *hazard = [Hazard new];
    
    hazard.hazardName = @"Ladder";
    hazard.solution = @"Do not go above the second to top rung of ladder";
    [_hazards addObject:hazard];
    
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
    if (indexPath.section < [_hazards count]) {
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
    return [_hazards count] +1;
    [tableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < [_hazards count]) {
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
    
    if (indexPath.section < [_hazards count]) {
        if (indexPath.row % 2) {
            NSString *CellIdentifier = @"SolutionCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            //            cell = [tableView dequeueReusableCellWithIdentifier:@"HazardCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            return cell;
            
        } else {
            
                
                NSString *CellIdentifier = @"HazardCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                //            cell = [tableView dequeueReusableCellWithIdentifier:@"HazardCell"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            return cell;
//            cell = [tableView dequeueReusableCellWithIdentifier:@"SolutionCell"];
            
        }
    } else {
        NSString *CellIdentifier = @"AddNewHazardCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        return cell;
    }
//    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= [_hazards count]) {
        Hazard *hazard = [Hazard new];
        [_hazards addObject:hazard];
        [tableView reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleNone;
    } else if (indexPath.section == [_hazards count]){
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_hazards removeObjectAtIndex:indexPath.row];
        //    NSArray *indexPaths = @[indexPath];
        //    [tableView deleteRowsAtIndexPaths:indexPaths
        //                     withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    
    
//    if (indexPath.row % 2) {
//        [tableView beginUpdates];
//        [_hazards removeObjectAtIndex:indexPath.row];
//        [_hazards removeObjectAtIndex:indexPath.row -1];
//        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
//        [tableView reloadData];
//        [tableView endUpdates];
//    } else {
//        [tableView beginUpdates];
//        [_hazards removeObjectAtIndex:indexPath.row];
//        [_hazards removeObjectAtIndex:indexPath.row +1];
//        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
//        [tableView reloadData];
//        [tableView endUpdates];
//    }
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
