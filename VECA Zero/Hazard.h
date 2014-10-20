//
//  Hazard.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/23/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hazard : NSObject <NSCoding>

@property (strong, nonatomic) NSString *hazardName;
@property (strong, nonatomic) NSString *solution;
@property (strong, nonatomic) UIImage *hazardImage;
@property BOOL checked;
@property BOOL solutionChecked;

- (void)toggleChecked;

- (void)toggleSolutionChecked;

@end
