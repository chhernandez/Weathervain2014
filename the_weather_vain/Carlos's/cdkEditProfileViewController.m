//
//  cdkEditProfileViewController.m
//  WeatherVain
//
//  Created by Carlos Hernandez on 4/12/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import "cdkEditProfileViewController.h"
#import "cdkMainViewController.h"

@interface cdkEditProfileViewController ()

@end

@implementation cdkEditProfileViewController


#pragma mark - NSURLConnectionDataDelegate

/* Callback delegate methods used for downloading the user's profile picture */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // As chuncks of the image are received, we build our data file
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // All data has been downloaded, now we can set the image in the header image view
    self.myFBImage.image = [UIImage imageWithData:self.imageData];
    
    // Add a nice corner radius to the image
    self.myFBImage.layer.cornerRadius = 8.0f;
    self.myFBImage.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"my username: %@", [PFUser currentUser]);
    //   NSlog(@"my passsord: %@", [PFUser currentPassword]);
    
  //   [[UILabel appearance] setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:15.0]];
    
    // code to see which fonts are available. chh 05012014
 /*   for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    */
    
 /*
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"blurredBG.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
  */  
    
    
    if (![PFUser currentUser]) { // No user logged in
        NSLog(@"current user %@", [PFUser currentUser]);
        
        //self.myWelcomeLabel.text = NSLocalizedString(@"Not logged in", nil);
        
        //   [self.parentViewController.tabBarController setSelectedIndex:1];
        //take the user to login screen if not logged in. chh 04102014
        cdkMainViewController *viewController = [[cdkMainViewController alloc] init];
        [self presentViewController:viewController animated:YES completion:nil];
        
    } else {
        NSLog(@"current user %@", [PFUser currentUser]);
        // Here we check to see if the user has closet items. chh 03162014
        //self.myWelcomeLabel.text = NSLocalizedString(@"Welcome", nil);
        
        self.myUsernameField.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [[PFUser currentUser] username]];
        
     //   self.myUsernameField.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:20];
        
        self.myPasswordField.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [[PFUser currentUser] password]];
        
        self.myEmailField.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [[PFUser currentUser] email]];
        
        PFUser *user = [PFUser currentUser];
        NSLog(@"gender user %@", user[@"gender"]);
        
        // self.myGenderField.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), user[@"gender"]];
        
        //
        
        if ([user[@"gender"] isEqual: @1]) {
            self.myGenderField.text = NSLocalizedString(@"male", nil);
            [self.myMFSwitch setOn:NO];
            
        } else {
            self.myGenderField.text = NSLocalizedString(@"female", nil);
            [self.myMFSwitch setOn:YES];
        }
        
        // Create request for user's Facebook data
        FBRequest *request = [FBRequest requestForMe];
        
        NSLog(@"FB request %@", request);
        NSLog(@"current user object id: %@", [[PFUser currentUser] objectId]);
        
        
        
        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                 NSLog(@"FB DATA %@", userData);
                
                
                NSString *facebookID = userData[@"id"];
                NSString *name = userData[@"name"];
                NSString *location = userData[@"location"][@"name"];
                NSString *gender = userData[@"gender"];
                NSString *birthday = userData[@"birthday"];
                NSString *relationship = userData[@"relationship_status"];
                
                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                
                NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                          cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                      timeoutInterval:2.0f];
                // Run network request asynchronously
                NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
                if (!urlConnection) {
                    NSLog(@"Failed to download picture");
                }
                
                NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectForKey:@"facebookID"]];
                
                //B. Assign the image data we fetched to the UIImageView
                [self.myFBImage setImageWithURL:[NSURL URLWithString:userImageURL]];
                
          //       *mygendervalue = [NSString stringWithFormat:NSLocalizedString("%@", nil),gender];
                
                
             //   self.myGenderField.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), gender];
                self.myDOBField.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), birthday];
                
                
            } else {
                
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                  NSLog(@"No FB DATA %@", userData);
            }
        }];

        
    };
 
    

    
    
}




- (IBAction)actionSaveProfile:(id)sender {
    
    int myGenderValue = 1;
    
    if (self.myMFSwitch.on) { myGenderValue = 0; };
    
    NSLog(@"my current user object id: %@", [[PFUser currentUser] objectId]);
    NSLog(@"my gender value: %@", [NSNumber numberWithInt:myGenderValue]);
    
    // set the gender base on user settings. chh 04162014
    
    PFUser *user = [PFUser currentUser];
    user[@"gender"] = [NSNumber numberWithInt:myGenderValue]; // attempt to change username
    [user save]; // This succeeds, since the user was authenticated on the device
    
    

      
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if([[alertView title] isEqualToString:@"Reset Password"])
    {
        if (buttonIndex == 0)
        {  // yes, send email
            //  NSString *numStrTempMin = [minTempValue stringValue];
            [PFUser requestPasswordResetForEmailInBackground:self.myEmailField.text];
        } else {
            // no, do nothing
            
        }
    }
}


- (IBAction)actionResetPW:(id)sender {
    
    
    NSLog(@"reset pw email: %@", self.myEmailField.text);
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Reset Password"];
    [alert setMessage:@"An email with reset instructions will be sent. Do you want to continue?"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert show];

}

- (IBAction)actionSwitchMF:(id)sender {
    
    if (self.myMFSwitch.on) {
        self.myGenderField.text = NSLocalizedString(@"female", nil);
        
    } else {
        self.myGenderField.text = NSLocalizedString(@"male", nil);
    };
    
}
@end
