//
//  SignInViewController.h
//  VECA Zero
//
//  Created by Daniel Fairbanks on 7/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPersonViewController.h"
#import "Person.h"
#import "Job.h"
#import "Task.h"

@class SignInViewController;
@class Person;
@class NSMutableArray;

@protocol SignInViewControllerDelegate <NSObject>

@optional

- (void)SignInViewController:(SignInViewController *)controller
                    didFinishSavingPersonArray:(NSMutableArray *)personsArray;



@end

@interface SignInViewController : UIViewController <AddPersonViewControllerDelegate>

@property (nonatomic, weak) id <SignInViewControllerDelegate> delegate;

@property (nonatomic, strong) Job *job;
@property (nonatomic, strong) Task *task;
@end
