//
//  cdkEditProfileViewController.h
//  WeatherVain
//
//  Created by Carlos Hernandez on 4/12/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface cdkEditProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *myWelcomeLabel;
@property (weak, nonatomic) IBOutlet UITextField *myUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *myPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *myEmailField;
@property (weak, nonatomic) IBOutlet UITextField *myGenderField;
@property (weak, nonatomic) IBOutlet UITextField *myDOBField;
@property (weak, nonatomic) IBOutlet UIImageView *myFBImage;
@property (weak, nonatomic) IBOutlet UISwitch *myMFSwitch;
- (IBAction)actionSaveProfile:(id)sender;
- (IBAction)actionResetPW:(id)sender;

- (IBAction)actionSwitchMF:(id)sender;
@property (nonatomic, strong) NSMutableData *imageData;
@end
