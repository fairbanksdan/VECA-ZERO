//
//  Person.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/23/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hazard.h"

@interface Person : NSObject <NSCoding>

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic) BOOL isInjured;
@property (nonatomic, strong) NSString *supervisor;
@property (nonatomic, strong) NSString *incidentDescription;
@property (nonatomic, strong) UIImage *checkInSignature;
@property (nonatomic, strong) UIImage *checkOutSignature;

@property (strong, nonatomic) NSMutableArray *personHazardsArray;

@end
