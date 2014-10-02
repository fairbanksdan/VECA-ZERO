//
//  Person.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/23/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding>

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) UIImage *checkInInitials;
@property (nonatomic, strong) UIImage *checkOutInitials;
@property (nonatomic) BOOL *injured;
@property (nonatomic, strong) NSString *supervisor;
@property (nonatomic, strong) NSString *incidentDescription;


@end
