//
//  HazardToBeCheckedTableViewCell.h
//  VECA Zero
//
//  Created by Dan Fairbanks on 10/17/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HazardToBeCheckedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *verticalLine;
@property (weak, nonatomic) IBOutlet UILabel *checkmarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *hazardLabel;

@end
