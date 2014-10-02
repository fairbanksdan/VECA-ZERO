//
//  HazardTableViewCell.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 10/1/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HazardTableViewCellDelegate <NSObject>

@end

@interface HazardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *hazardTextField;
//- (IBAction)hazardTFTextChanged:(UITextField *)sender;

@property (nonatomic, weak) id <HazardTableViewCellDelegate> delegate;

@end
