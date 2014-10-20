//
//  HazardTableViewCell.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 10/1/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

//@protocol HazardTableViewCellDelegate <NSObject>
//
//@end

@interface HazardTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hazardLabel;
@property (weak, nonatomic) IBOutlet UILabel *solutionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thinLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cellSeperatorImageView;

//- (IBAction)hazardTFTextChanged:(UITextField *)sender;

//@property (nonatomic, weak) id <HazardTableViewCellDelegate> delegate;

@end
