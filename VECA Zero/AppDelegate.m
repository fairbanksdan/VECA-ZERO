//
//  AppDelegate.m
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/18/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "AppDelegate.h"
#import "DataModel.h"
#import "HomeViewController.h"
#import "JobsViewController.h"

@implementation AppDelegate
//{
//    DataModel *_dataModel;
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DataModel.myDataModel.firstTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstTime"];
    
    if (!DataModel.myDataModel.firstTime)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UINavigationController *JobsViewController = [MainStoryBoard instantiateViewControllerWithIdentifier:@"NavController"];
        self.window.rootViewController = JobsViewController;
    }
    
    DataModel.myDataModel.mainUser.checkInSignature = nil;
    DataModel.myDataModel.mainUser.checkOutSignature = nil;
    DataModel.myDataModel.mainUser.isInjured = nil;
    DataModel.myDataModel.mainUser.incidentDescription = nil;
    DataModel.myDataModel.mainUser.supervisor = nil;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)saveData
{
    [DataModel.myDataModel saveJobs];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DataModel.myDataModel.mainUser.checkInSignature = nil;
    DataModel.myDataModel.mainUser.checkOutSignature = nil;
    DataModel.myDataModel.mainUser.isInjured = nil;
    DataModel.myDataModel.mainUser.incidentDescription = nil;
    DataModel.myDataModel.mainUser.supervisor = nil;
    [self saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DataModel.myDataModel.mainUser.checkInSignature = nil;
    DataModel.myDataModel.mainUser.checkOutSignature = nil;
    DataModel.myDataModel.mainUser.isInjured = nil;
    DataModel.myDataModel.mainUser.incidentDescription = nil;
    DataModel.myDataModel.mainUser.supervisor = nil;
    [self saveData];
}

@end
