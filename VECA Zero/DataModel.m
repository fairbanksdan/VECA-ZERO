//
//  DataModel.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 9/29/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

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

- (void)saveJobs
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:self.tasksForJobs forKey:@"tasksForJobs"];
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
        self.tasksForJobs = [unarchiver decodeObjectForKey:@"tasksForJobs"];

        [unarchiver finishDecoding];
    } else {
        self.tasksForJobs = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

- (id)init
{
    if ((self = [super init])) {
        [self loadJobs];
    }
    return self;
}


@end
