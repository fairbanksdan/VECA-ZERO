//
//  ViewController.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/18/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddJobViewController.h"

@interface JobsViewController : UIViewController <AddJobViewControllerDelegate>


@property (nonatomic, strong) NSMutableArray *jobsArray;
@property (strong, nonatomic) UIColor *navBarColor;

@end
