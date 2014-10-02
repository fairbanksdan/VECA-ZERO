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
    
    UITextField *_newTextField;
    UITextField *_solutionTextField;
    NSString *_string;
    NSMutableArray *_textFields;
    NSMutableArray *_solutionTextFields;
//    NSMutableArray *_tags;
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
    
    _textFields = [[NSMutableArray alloc] initWithCapacity:20];
    
    _solutionTextFields = [[NSMutableArray alloc] initWithCapacity:20];
    
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

    if (indexPath.section < ([_localHazardsArray count]+ 1)) {
        
        if (indexPath.row % 2) {
            NSString *CellIdentifier = @"SolutionCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if (indexPath.section >= ([_solutionTextFields count])) {
                UITextField *cellTextField = [UITextField new];
                cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, 280, 80)];
                
                [cellTextField setBorderStyle:UITextBorderStyleNone];
                [cellTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                cellTextField.placeholder = @"Solution";
                
                
                [_solutionTextFields addObject:cellTextField];
                
                [cell addSubview:cellTextField];
                
                return cell;
                
            } else {
                
                return cell;
                
            }
        
            
            
            
            return cell;
            
        } else {
                NSString *CellIdentifier = @"HazardCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
            if (indexPath.section >= ([_textFields count])) {
                UITextField *cellTextField = [UITextField new];
                cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, 280, 30)];
                
                [cellTextField setBorderStyle:UITextBorderStyleNone];
                cellTextField.placeholder = @"Hazard";
                
                [_textFields addObject:cellTextField];
                
                [cell addSubview:cellTextField];
                
                return cell;
                
            } else {
            
                return cell;
            
            }
        }
    } else {
        NSString *CellIdentifier = @"AddNewHazardCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ([_localHazardsArray count]+ 1)) {
        _string = @"1";
        [_localHazardsArray addObject:_string];
        
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

        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CheckIn"]) {
        [self saveHazard];
    }
}

-(void)saveHazard {
    int i = 0;
    while (i < ([_textFields count])) {
        
        _newTextField = [_textFields objectAtIndex:i];
        _solutionTextField = [_solutionTextFields objectAtIndex:i];

        Hazard *hazard = [Hazard new];
        hazard.hazardName = _newTextField.text;
        hazard.solution = _solutionTextField.text;
        
        [self.delegate AddHazardsViewController:self didFinishAddingItem:hazard];
        
        NSLog(@"Hazard Name is %@", hazard.hazardName);
        NSLog(@"Hazard Solution is %@", hazard.solution);
        NSLog(@"_textFields count is: %lu", [_textFields count]);
        NSLog(@"_textFields count is: %lu", [_solutionTextFields count]);
        
        i += 1;
    }
}

@end
