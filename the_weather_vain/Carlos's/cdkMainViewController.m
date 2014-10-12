//
//  cdkMainViewController.m
//  FashionExample
//
//  Created by itsadmin on 2/28/14.
//  Copyright (c) 2014 Carlos Hernandez. All rights reserved.
//

#import "cdkMainViewController.h"
#import "cdkMoreTableViewController.h"
#import "cdkEditProfileViewController.h"
#import "WXManager.h"

@interface cdkMainViewController ()

@end

@implementation cdkMainViewController



#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //
   //     [[UILabel appearance] setFont:[UIFont fontWithName:@"RobotoCondensed-Regular.ttf" size:17.0]];
 
    /* ************  This code for some reason is producing a black background on the iphone devices. remove and added a plain light gray background chh 05012014
     
     UIGraphicsBeginImageContext(self.view.frame.size);
     [[UIImage imageNamed:@"blurredBG.png"] drawInRect:self.view.bounds];
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     self.view.backgroundColor = [UIColor colorWithPatternImage:image];
     
     
     *******************   */
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if([[alertView title] isEqualToString:@"Account Required"])
    {
        if (buttonIndex == 0)
        {
            // Yes, do something
            
            
            // Create the log in view controller
            PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
            
            //   logInViewController.fields= PFLogInFieldsUsernameAndPassword| PFLogInFieldsLogInButton|PFLogInFieldsSignUpButton|PFLogInFieldsPasswordForgotten;
            
            
            [logInViewController setDelegate:self]; // Set ourselves as the delegate
            
           // logInViewController.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"parseloginbg.jpg"]];
            
            
            [logInViewController.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wvlogo.png"]]];
            
            //     [logInViewController.logInView.usernameField setBackgroundColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
            
            //    [logInViewController.logInView.passwordField setBackgroundColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
            
            //     [logInViewController.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
            
            
            
            //      logInViewController.logInView.logo = @"myLogo";
            
            //     label.text = @"My Logo";
            //     [label sizeToFit];
            //    self.logInView.logo = label;
            
            
            
            // Create the sign up view controller
            PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
            [signUpViewController setDelegate:self]; // Set ourselves as the delegate
            
            
            [signUpViewController.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wvlogo.png"]]];
            
            // Assign our sign up controller to be displayed from the login controller
            [logInViewController setSignUpController:signUpViewController];
            
            
            // Present the log in view controller
            [self presentViewController:logInViewController animated:YES completion:NULL];
            
        }
        else if (buttonIndex == 1)
        {
            // No, do nothing and return
            [self.parentViewController.tabBarController setSelectedIndex:0];
        }
        
    };
    
   /* else
    {
        if (buttonIndex == 0)
        {
            // Yes, do something
            
            
            if (![PFUser currentUser]) { // No user logged in
                NSLog(@"current user %@", [PFUser currentUser]);
                
                //   [self.parentViewController.tabBarController setSelectedIndex:1];
                //take the user to login screen if not logged in. chh 04102014
                cdkMainViewController *viewController = [[cdkMainViewController alloc] init];
                [self presentViewController:viewController animated:YES completion:nil];
                
            } else {
                NSLog(@"current user %@", [PFUser currentUser]);
                // Here we check to see if the user has closet items. chh 03162014
                
                
                PFQuery *query = [PFQuery queryWithClassName:@"Closet"];
                
                [query whereKey:@"User" equalTo:[PFUser currentUser]];
                
                
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                    
                    if (!error) {
                        // The find succeeded.
                        NSLog(@"Successfully retrieved %d objects.", objects.count);
                        // Do something with the found objects
                        
                        if (objects.count == 0) {
                            NSLog(@" No objects to delete: %d objects.", objects.count);
                        } else {
                            
                            
                            // delete all user closet objects
                            // just need to delete objects since closet will repopulate default closet upon entry again. chh 04112014
                            // Do something with the found objects
                            for (PFObject *object in objects) {
                                [object deleteInBackground];
                            }
                        }
                        
                    } // end of no error
                }]; // end of query
            }; // end of if no currentuser
            
            // The InBackground methods are asynchronous, so any code after this will run
            // immediately.  Any code that depends on the query result should be moved
            // inside the completion block above.
            
        }
        else if (buttonIndex == 1)
        {
            // No, do nothing and return
            [self.myClosetSwitch setOn:NO];
        }
        
    }; // end of if else "login required"
    */
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        
        //provide a popup dialog to explain why login is required. chh 04162014
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Account Required"];
        [alert setMessage:@"To share photos and customize your clothing recommendations, please login or sign up for a new account. Sign up or login now?"];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"Yes"];
        [alert addButtonWithTitle:@"No"];
        [alert show];
        
    }
}


-(void)viewDidLoad{
    self.datePicker.minimumDate = [NSDate date];
    
    // background image
    /*UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"blurredBG.png"]];
    self.view.backgroundColor = background;
    */
    
    // navigation bar
    UINavigationBar *home_NavBar = [self.navigationController navigationBar];
    UIImage *img = [UIImage imageNamed:@"navBGblue.png"];
    [home_NavBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    
    
}

#pragma mark - PFLogInViewControllerDelegate



// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}


// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {

    [self linkFacebookLoginToParseUser:user];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
    //if dismissed, take the user back to home tab. chh 04152014
    [self.parentViewController.tabBarController setSelectedIndex:0];
    
}


- (void) linkFacebookLoginToParseUser:(PFUser *) user{
    // The permissions requested from the user
    NSArray *permissionsArray = @[@"basic_info"];
    
    if (![PFFacebookUtils isLinkedWithUser:user]) {
        [PFFacebookUtils linkUser:user permissions:permissionsArray block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Woohoo, user logged in with Facebook!");
                
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
                        PFUser *currentUser = [PFUser currentUser];
                        
                        [currentUser setObject:facebookID forKey:@"facebookID"];
                        [currentUser saveInBackground];
                        
                        //       NSString *name = userData[@"name"];
                        //       NSString *location = userData[@"location"][@"name"];
                        NSString *gender = userData[@"gender"];
                        //       NSString *birthday = userData[@"birthday"];
                        //       NSString *relationship = userData[@"relationship_status"];
                        
                        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                        
                        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                              timeoutInterval:2.0f];
                        // Run network request asynchronously
                        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
                        if (!urlConnection) {
                            NSLog(@"Failed to download picture");
                        }
                        
                        //get gender value from facebook but is there's none, then default it to female.
                        
                        if ([gender isEqual: @"male"]) {
                            //    [[PFUser currentUser] gender]] = @1;
                            
                            PFUser *user = [PFUser currentUser];
                            user[@"gender"] = @1; // attempt to change username
                            [user save]; // This succeeds, since the user was authenticated on the device
                            
                            
                        } else {
                            
                            PFUser *user = [PFUser currentUser];
                            user[@"gender"] = @0; // attempt to change username
                            [user save]; // This succeeds, since the user was authenticated on the device
                        }
                        
                    } else {
                        
                        // result is a dictionary with the user's Facebook data
                        NSDictionary *userData = (NSDictionary *)result;
                        NSLog(@"No FB DATA %@", userData);            }
                }];
                
            }
        }];
        
        NSLog(@"my username after if logged in: %@", [PFUser currentUser]);
        
    }
    

}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    
    // other fields can be set just like with PFObject. chh 04162014
    // set the default gender to female = 0;
    user[@"gender"] = @0;
    [user saveInBackground];
    
    [self linkFacebookLoginToParseUser:user];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

#pragma mark - ()

/*  move the signout button to the navigation bar to make room for settings. chh 04/10/2014
 
 - (IBAction)logOutButtonTapAction:(id)sender {
 .
 NSLog(@"In the logout function...");
 
 [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
 if (succeeded) {
 
 NSLog(@"The user is no longer associated with their Facebook account.");
 
 [PFUser logOut];
 [self.navigationController popViewControllerAnimated:YES];
 }
 }];
 
 
 //   [self.parentViewController.tabBarController setSelectedIndex:1];
 [PFUser logOut];
 
 //   [self.parentViewController.tabBarController setSelectedIndex:3];
 [self.parentViewController.tabBarController setSelectedIndex:0];
 //  [self.navigationController popViewControllerAnimated:YES];
 
 
 } */

- (IBAction)mySignOutButton:(id)sender {
    
    NSLog(@"In the logout function...");
    /*
     [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
     if (succeeded) {
     
     NSLog(@"The user is no longer associated with their Facebook account.");
     
     [PFUser logOut];
     [self.navigationController popViewControllerAnimated:YES];
     }
     }];
     */
    
    //   [self.parentViewController.tabBarController setSelectedIndex:1];
    [PFUser logOut];
    
    //   [self.parentViewController.tabBarController setSelectedIndex:3];
    [self.parentViewController.tabBarController setSelectedIndex:0];
    //  [self.navigationController popViewControllerAnimated:YES];
    
}

/*  remove duplicate alertview. chh 04162014
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 if (buttonIndex == 0)
 {
 // Yes, do something
 
 
 
 if (![PFUser currentUser]) { // No user logged in
 NSLog(@"current user %@", [PFUser currentUser]);
 
 //   [self.parentViewController.tabBarController setSelectedIndex:1];
 //take the user to login screen if not logged in. chh 04102014
 cdkMainViewController *viewController = [[cdkMainViewController alloc] init];
 [self presentViewController:viewController animated:YES completion:nil];
 
 } else {
 NSLog(@"current user %@", [PFUser currentUser]);
 // Here we check to see if the user has closet items. chh 03162014
 
 
 PFQuery *query = [PFQuery queryWithClassName:@"Closet"];
 
 [query whereKey:@"User" equalTo:[PFUser currentUser]];
 
 
 
 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
 
 if (!error) {
 // The find succeeded.
 NSLog(@"Successfully retrieved %d objects.", objects.count);
 // Do something with the found objects
 
 if (objects.count == 0) {
 NSLog(@" No objects to delete: %d objects.", objects.count);
 } else {
 
 
 // delete all user closet objects
 // just need to delete objects since closet will repopulate default closet upon entry again. chh 04112014
 // Do something with the found objects
 for (PFObject *object in objects) {
 [object deleteInBackground];
 }
 }
 
 } // end of no error
 }]; // end of query
 }; // end of if no currentuser
 
 // The InBackground methods are asynchronous, so any code after this will run
 // immediately.  Any code that depends on the query result should be moved
 // inside the completion block above.
 
 }
 else if (buttonIndex == 1)
 {
 // No, do nothing and return
 [self.myClosetSwitch setOn:NO];
 }
 
 }  */

/*
- (IBAction)myClosetReset:(id)sender {
    
    // retrieve all records from closet with user id. chh 04112014
    
    // check to see if user is log in, else send user to login screen
    //  NSLog(@"current user %@", [PFUser currentUser]);
    
    if (self.myClosetSwitch.on) {
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Reset Closet"];
        [alert setMessage:@"Are you sure you want to reset?"];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"Yes"];
        [alert addButtonWithTitle:@"No"];
        [alert show];
        
        //     [alert release];
        
        //       [alert release];
        
    }; // end of my closet switch is on
    
    
}*/

- (IBAction)mySaveNotificationButton:(id)sender {
    [self scheduleNotification];
    
}

-(void) scheduleNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [[RACObserve([WXManager sharedManager], currentCondition)
      // 2
      /*Delivers any changes on the main thread since you’re updating the UI.*/
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(WXCondition *newCondition) {
         
         
         UILocalNotification *localNotification = [[UILocalNotification alloc] init];
         NSDate *now = self.datePicker.date;
         
         localNotification.fireDate = now;
         localNotification.timeZone = [NSTimeZone defaultTimeZone];
         
         localNotification.alertBody = [NSString stringWithFormat:@"%@  %.0f°  %@", newCondition.locationName,      [newCondition.temperature floatValue] , newCondition.condition];
         
         localNotification.soundName = UILocalNotificationDefaultSoundName;
         
         //Reminder happens every day
         localNotification.repeatInterval = NSDayCalendarUnit;
         
         [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
         
     }];
    
}


//- (IBAction)action_save:(id)sender {
//    [self scheduleNotification];
//}
@end
