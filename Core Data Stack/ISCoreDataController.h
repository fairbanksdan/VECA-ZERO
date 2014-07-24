//
//  ISCoreDataController.h
//  iStock
//
//  Created by Michael Babiy on 7/22/14.
//  Copyright (c) 2014 Getty Images. All rights reserved.
//

@import UIKit;
@import CoreData;

@interface ISCoreDataController : NSObject

+ (instancetype)sharedController;

- (NSManagedObjectContext *)managedObjectContext;
- (void)saveMasterContext;
- (void)saveBackgroundContext;

@end
