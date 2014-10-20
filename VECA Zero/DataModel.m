//
//  DataModel.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 9/29/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

+ (DataModel *)myDataModel {
    static DataModel *sharedModel = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        sharedModel = [[self alloc] init];
//        sharedModel.jobsArray = [[NSMutableArray alloc] init];
    });
    return sharedModel;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self loadJobs];
//        [self loadMainUser];
//        DataModel *_dataModel = [DataModel myDataModel];
//        _jobsArray = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return  self;
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory]
            stringByAppendingPathComponent:@"VECA Zero.plist"];
}

- (void)saveMainUser {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:_mainUser forKey:@"mainUser"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

//- (void)loadMainUser {
//    NSString *path = [self dataFilePath];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
//                                         initForReadingWithData:data];
//        _mainUser= [unarchiver decodeObjectForKey:@"mainUser"];
//        
//        [unarchiver finishDecoding];
//    } else {
//        _mainUser = [Person new];
//    }
//}

- (void)saveJobs
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:_jobsArray forKey:@"tasksForJobs"];
    [archiver encodeObject:_mainUser forKey:@"mainUser"];
    
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadJobs
{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                         initForReadingWithData:data];
        _jobsArray = [unarchiver decodeObjectForKey:@"tasksForJobs"];
        _mainUser= [unarchiver decodeObjectForKey:@"mainUser"];

        [unarchiver finishDecoding];
    } else {
        _jobsArray = [[NSMutableArray alloc] initWithCapacity:20];
        _mainUser = [Person new];
    }
}

- (NSInteger)indexOfSelectedJob {
    return [[NSUserDefaults standardUserDefaults]
            integerForKey:@"JobIndex"];
}

- (void)setIndexOfSelectedJob:(NSInteger)index {
    [[NSUserDefaults standardUserDefaults]
     setInteger:index forKey:@"JobIndex"];
}


@end
