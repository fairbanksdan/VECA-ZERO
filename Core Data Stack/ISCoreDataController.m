//
//  ISCoreDataController.m
//  iStock
//
//  Created by Michael Babiy on 7/22/14.
//  Copyright (c) 2014 Getty Images. All rights reserved.
//

#import "ISCoreDataController.h"

@interface ISCoreDataController ()

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext *masterManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;

@end

@implementation ISCoreDataController

+ (instancetype)sharedController {
    static ISCoreDataController *sharedController;
    static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedController = [[[self class]alloc]init];
        });
    
    return sharedController;
}

#pragma mark - Instance Methods

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context;
    NSManagedObjectContext *masterContext = self.masterManagedObjectContext;
    if (masterContext != nil) {
        context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        [context performBlockAndWait:^{
            [context setParentContext:masterContext];
        }];
    }
    
    return context;
}

- (void)saveMasterContext {
    [self.masterManagedObjectContext performBlockAndWait:^{
        NSError *error;
        BOOL saved = [self.masterManagedObjectContext save:&error];
        if (!saved) {
            NSLog(@"Could not save master context due to %@", error.localizedDescription);
        }
    }];
}

- (void)saveBackgroundContext {
    [self.backgroundManagedObjectContext performBlockAndWait:^{
        NSError *error;
        BOOL saved = [self.backgroundManagedObjectContext save:&error];
        if (!saved) {
            NSLog(@"Could not save background context due to %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Helper Methods

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
}

- (NSURL *)storeURL {
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    NSString *bundleName = [[[NSBundle mainBundle]infoDictionary]valueForKey:(id)kCFBundleNameKey];
    return [applicationDocumentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", bundleName]];
}

- (NSString *)modelName {
    return [[[NSBundle mainBundle]infoDictionary]valueForKey:(id)kCFBundleNameKey];
}

#pragma mark - Core Data Stack

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle]URLForResource:[self modelName] withExtension:@"momd"];
    
    return [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error.localizedDescription, error.userInfo);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)masterManagedObjectContext {
    if (_masterManagedObjectContext != nil) {
        return _masterManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        _masterManagedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_masterManagedObjectContext performBlockAndWait:^{
            [_masterManagedObjectContext setPersistentStoreCoordinator:coordinator];
        }];
    }
    
    return _masterManagedObjectContext;
}

- (NSManagedObjectContext *)backgroundManagedObjectContext {
    if (_masterManagedObjectContext != nil) {
        return _backgroundManagedObjectContext;
    }
    
    NSManagedObjectContext *masterContext = self.masterManagedObjectContext;
    if (masterContext != nil) {
        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundManagedObjectContext performBlockAndWait:^{
            [_backgroundManagedObjectContext setParentContext:masterContext];
        }];
    }
    
    return _backgroundManagedObjectContext;
}

@end
