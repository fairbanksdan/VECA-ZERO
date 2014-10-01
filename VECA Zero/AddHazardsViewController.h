//
//  AddHazardsViewController.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddHazardsViewController;
@class Hazard;

@protocol AddHazardsViewControllerDelegate <NSObject>

- (void)AddHazardsViewControllerDidCancel:(AddHazardsViewController *)controller;

- (void)AddHazardsViewController:(AddHazardsViewController *)controller didFinishAddingItem:(Hazard *)hazard;

- (void)AddHazardsViewController:(AddHazardsViewController *)controller didFinishEditingItem:(Hazard *)hazard;

@end

@interface AddHazardsViewController : UIViewController


@property (nonatomic, weak) id <AddHazardsViewControllerDelegate> delegate;



@end
