//
//  ProfileViewController.h
//  WeatherVain
//
//  Created by Tehreem Syed on 4/14/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property BOOL showedLoginError;
@property (strong,nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIView *top_profile_view;

@end
