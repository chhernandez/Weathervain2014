//
//  cdkMainViewController.h
//  FashionExample
//
//  Created by itsadmin on 2/28/14.
//  Copyright (c) 2014 Carlos Hernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface cdkMainViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>


//@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

//- (IBAction)logOutButtonTapAction:(id)sender;
//- (IBAction)mySignOutButton:(id)sender;
//- (IBAction)myClosetReset:(id)sender;
- (IBAction)mySaveNotificationButton:(id)sender;


//@property (weak, nonatomic) IBOutlet UISwitch *myClosetSwitch;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
//- (IBAction)action_save:(id)sender;

@end
