//
//  DataController.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 8/6/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "DataController.h"
#import "Job.h"
#import "Task.h"
#import "Hazard.h"

@implementation DataController

+(DataController *)sharedData {
    static dispatch_once_t pred;
    static DataController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[DataController alloc] initWithJobs];
    });
    return shared;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jobArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"JobCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        
    }
    
    Job *newJob = [self.jobArray objectAtIndex:indexPath.row];
    
//    cell.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:.3];
//    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = newJob.jobName;
    
    
    return cell;
    
}

-(instancetype)initWithJobs {
    self = [super init];
    
    NSString *jobPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Job.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:jobPath])
    {
        self.jobArray = [NSKeyedUnarchiver unarchiveObjectWithFile:jobPath];
    } else {
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"job" ofType:@"plist"];
        NSDictionary *peopleDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        NSArray *tempJobArray = [peopleDictionary objectForKey:@"Jobs"];
        
        self.jobArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *jobDictionary in tempJobArray) {
            Job *newJob = [[Job alloc] init];
            newJob.jobNumber = [jobDictionary objectForKey:@"JobNumber"];
            newJob.jobName = [jobDictionary objectForKey:@"JobName"];
            [self.jobArray addObject:newJob];
        }
    
        [NSKeyedArchiver archiveRootObject:self.jobArray toFile:jobPath];
    }
    return self;
}

-(NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

-(BOOL)checkForPlistFileInDocs:(NSString*)fileName
{
    NSError *error;
    
    NSFileManager *myManager = [NSFileManager defaultManager];
    
    NSString *pathForPlistInBundle = [[NSBundle mainBundle] pathForResource:@"job" ofType:@"plist"];
    
    NSString *pathForPlistInDocs = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
    
    return [myManager fileExistsAtPath:pathForPlistInDocs];
    
    
    [myManager copyItemAtPath:pathForPlistInBundle toPath:pathForPlistInDocs error:&error];
    
    
    return NO;
}

-(void)save
{
    NSString *jobPlistPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Job.plist"];
    
    [NSKeyedArchiver archiveRootObject:self.jobArray toFile:jobPlistPath];
    
}


@end
