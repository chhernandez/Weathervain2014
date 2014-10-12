//
//  cdkClosetViewController.m
//  FashionExample
//
//  Created by Carlos Hernandez on 3/2/14.
//  Copyright (c) 2014 Carlos Hernandez. All rights reserved.
//

#import "cdkClosetViewController.h"
#import "cdkCellType.h"
#import "cdkMasterViewController.h"
#import "cdkMainViewController.h"
#import "cdkMoreTableViewController.h"
#import "cdkEditProfileViewController.h"
#import <Parse/Parse.h>

BOOL retValue;

//#import "WXController.h"

@interface cdkClosetViewController ()

@end

@implementation cdkClosetViewController

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if([[alertView title] isEqualToString:@"Reset Closet"])
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
                        
 
                        NSLog(@"current user %@", [PFUser currentUser]);
            
                        
                        [self createCustomCloset2];
                        
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
          //  [self.myClosetSwitch setOn:NO];
        }
        
    }; // end of if "Reset Closet"
    
    
}


#pragma mark - Prepare for Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([segue.identifier isEqualToString:@"resetpush"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Reset Closet"];
        [alert setMessage:@"Are you sure you want to reset?"];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"Yes"];
        [alert addButtonWithTitle:@"No"];
        [alert show];
        
        
        
       // return;
    }
    
    if ([segue.identifier isEqualToString:@"celltomasterpush"]) {
        
        
        UICollectionViewCell *cell = (UICollectionViewCell *)sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
        cdkMasterViewController *myListViewController = (cdkMasterViewController *)segue.destinationViewController;
        myListViewController.TypeList = [self.typeArray objectAtIndex:indexPath.row];
        
   
    }
    

    
}



-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.typeArray.count;
    
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    cdkCellType * aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    aCell.myNewLabel.text = self.typeArray[indexPath.row];
    
    UIImage *typeImage = [[UIImage alloc] init];
    typeImage = [UIImage imageNamed:[self.typeImages objectAtIndex:indexPath.row]];
    aCell.myNewImage.image = typeImage;
    
    //   aCell.myNewLabel.text = [NSString stringWithFormat:@"Rating: "];
    
    //aCell.myTypeLabel.text = self.typeArray[indexPath.row];
    
    // to add image to the cell, add images with suffix numbering and use this code template:
    //aCell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"myImageIcon%d.jpg", imageNumber]];
    
    return aCell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"blurredBG.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
}
*/

/*
 
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 
 
 if([[alertView title] isEqualToString:@"Account Required"])
 {
 if (buttonIndex == 0)
 {  // yes, send email
 
 [self.parentViewController.tabBarController setSelectedIndex:0];
 
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
 */


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   //     [[UILabel appearance] setFont:[UIFont fontWithName:@"RobotoCondensed-Regular.ttf" size:17.0]];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"blurredBG.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    self.typeArray = @[@"Tops", @"Outerwear", @"Bottoms", @"Accessories", @"Shoes", @"One Piece"];
    self.typeImages = @[@"tops.png", @"outerwear.png", @"bottoms.png", @"accessories.png", @"shoes.png", @"dress.png"];
    
    // check to see if user is log in, else send user to login screen
    //  NSLog(@"current user %@", [PFUser currentUser]);
    
    
    
    
    
    if (![PFUser currentUser]) { // No user logged in
        NSLog(@"current user %@", [PFUser currentUser]);
        
        
        // show popup messsage to take user to login process before access to closet. chh 04192014
        
        
        UIAlertView *accountAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Account Required" message:@"To access your closet please log in or sign up for an account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        // Display the Hello World Message
        [accountAlert show];
        
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Account Required"];
        [alert setMessage:@"To access your closet please go to account setting and log in or sign up for an account."];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"Ok"];
        // [alert addButtonWithTitle:@"No"];
        [alert show];
        
        
        //  [self.parentViewController.tabBarController setSelectedIndex:0];
        
        //   [self.navigationController popViewControllerAnimated:YES];
        
        //take the user to login screen if not logged in. chh 04102014
        
        //  [self dismissViewControllerAnimated:YES completion:nil];
        //    cdkMoreTableViewController *viewController = [[cdkMoreTableViewController alloc] init];
        //  [self presentViewController:viewController animated:YES completion:nil];
        
        //create and show the login/signup view. chh
        
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        
        [logInViewController.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wvlogo.png"]]];
        
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        
        [signUpViewController.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wvlogo.png"]]];
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
        
        
        
        
    } else {
        NSLog(@"current user %@", [PFUser currentUser]);
        
        
        [self createCustomCloset2];
        
        
        
    }; // end of check to see if the user is logged in. chh 04092014
    
    
    /*
     
     
     // If Pull To Refresh is enabled, query against the network by default.
     if (self.pullToRefreshEnabled) {
     query.cachePolicy = kPFCachePolicyNetworkOnly;
     }
     
     NSLog(@"count of closet by user query: %lu", (unsigned long)self.objects.count);
     
     // If no objects are loaded in memory, we look to the cache first to fill the table
     // and then subsequently do a query against the network.
     if (self.objects.count == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     
     NSLog(@"query in cache: %u", query.cachePolicy);
     
     
     
     */
    
    
    
}


-(BOOL)checkIfEmptyCloset:(PFUser*) currUser{
    //(void)someMethodWithValue:(SomeType)value;
    // Here we check to see if the user has closet items. chh 03162014
    retValue = false;
    
    //NSLog(@"got here");
    PFQuery *query = [PFQuery queryWithClassName:@"Closet"];
    
    [query whereKey:@"User" equalTo: currUser];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            NSLog(@">>>>>>>>>>>> User is registered.");
            if (objects.count == 0) {
                retValue = true;
                NSLog(@">>>>>>>>>>>> There's nothing in the closet so it should return true.");
            }
            else{
                retValue = false;
                NSLog(@">>>>>>>>>>>> but it's returning false.");
            }
            //  return false;
        } else {
            //retValue = false;
            // Log details of the failure
            //return false;
            NSLog(@"Error getting user closet: %@ %@", error, [error userInfo]);
        }
    }]; // end of getting custom closet per logged in user. chh 04092014
    return retValue;
}




-(void)createCustomCloset:(PFUser*) currUser{
    //(void)someMethodWithValue:(SomeType)value;
    // Here we check to see if the user has closet items. chh 03162014
    
    //NSLog(@"got here");
    
    PFQuery *query = [PFQuery queryWithClassName:@"Closet"];
    
    [query whereKey:@"User" equalTo: currUser];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu objects in create custom closet.", (unsigned long)objects.count);
            // Do something with the found objects
            
            if (objects.count == 0) {
                NSLog(@"No objects in closet. Filling Closet.");
                PFQuery *defaultquery = [PFQuery queryWithClassName:@"DefaultCloset"];
                [defaultquery findObjectsInBackgroundWithBlock:^(NSArray *defaultobjects, NSError *error) {
                    
                    
                    if (!error) {
                        NSLog(@".....More Filling Closet.");
                        // The find succeeded.
                        //   NSLog(@"Successfully retrieved %d objects.", defaultobjects.count);
                        // Do something with the found objects
 
                        for (PFObject *object in defaultobjects) {
                            //      NSLog(@"copying default object to custom object id %@", object.objectId);
                            //  NSLog(@"my object in copy contains: %@", object);
                            
                            
                            //  Next section is all about copying the default closet into the users closet one item at a time.  chh 03152014
                            
                            //       NSNumber *myBlack = [object objectForKey:@"Black"];
                            
                            //  NSLog(@"my black value in copy contains: %@", myBlack);
                            //
                            //       NSNumber *myBlue = [object objectForKey:@"Blue"];
                            NSNumber *myFrigid = [object objectForKey:@"Frigid"];
                            NSNumber *myCold = [object objectForKey:@"Cold"];
                            NSString *myDescription = object[@"Description"];
                            PFFile *myImage = [object objectForKey:@"Image"];
                            
                            //    NSLog(@"my image value in copy contains: %@", myImage);
                            
                            NSNumber *myGender = [object objectForKey:@"Gender"];
                            //        NSNumber *myGreen = [object objectForKey:@"Green"];
                            NSNumber *myHot = [object objectForKey:@"Hot"];
                            
                            
                            NSString *myLabel = object[@"Label"];
                            NSNumber *myMild = [object objectForKey:@"Mild"];
                            //         NSNumber *myOrange = [object objectForKey:@"Orange"];
                            //        NSNumber *myPurple = [object objectForKey:@"Purple"];
                            NSNumber *myBrisk = [object objectForKey:@"Brisk"];
                            NSNumber *myWarm = [object objectForKey:@"Warm"];
                            NSNumber *myRating = [object objectForKey:@"Rating"];
                            NSNumber *myRainy = [object objectForKey:@"Rainy"];
                            //   NSNumber *myRed = [object objectForKey:@"Red"];
                            NSNumber *myStatus = [object objectForKey:@"Status"];
                            NSNumber *mySizzling = [object objectForKey:@"Sizzling"];
                            
                            //   NSNumber *myTempMax = [object objectForKey:@"TempMax"];
                            //  NSNumber *myTempMin = [object objectForKey:@"TempMin"];
                            NSNumber *myTypeID = [object objectForKey:@"TypeID"];
                            
                            
                            //    NSNumber *myWhite = [object objectForKey:@"White"];
                            NSNumber *myWindy = [object objectForKey:@"Windy"];
                            //    NSNumber *myYellow = [object objectForKey:@"Yellow"];
                            
                            
                            //PFUser *user = [PFUser currentUser];
                            PFObject *newItem = [PFObject objectWithClassName:@"Closet"];
                            
                            newItem[@"User"] = currUser;
                            
                            
                            //      newItem[@"Black"] = myBlack;
                            //      newItem[@"Blue"] = myBlue;
                            newItem[@"Frigid"] = myFrigid;
                            newItem[@"Cold"] = myCold;
                            newItem[@"Rainy"] = myRainy;
                            newItem[@"Warm"] = myWarm;
                            newItem[@"Description"] = myDescription;
                            newItem[@"Image"] = myImage;
                            newItem[@"Gender"] = myGender;
                            //    newItem[@"Green"] = myGreen;
                            newItem[@"Hot"] = myHot;
                            newItem[@"Label"] = myLabel;
                            newItem[@"Mild"] = myMild;
                            //    newItem[@"Orange"] = myOrange;
                            //    newItem[@"Purple"] = myPurple;
                            newItem[@"Brisk"] = myBrisk;
                            newItem[@"Rating"] = myRating;
                            //    newItem[@"Red"] = myRed;
                            newItem[@"Status"] = myStatus;
                            newItem[@"Sizzling"] = mySizzling;
                            //    newItem[@"TempMax"] = myTempMax;
                            //   newItem[@"TempMin"] = myTempMin;
                            newItem[@"TypeID"] = myTypeID;
                            //    newItem[@"White"] = myWhite;
                            newItem[@"Windy"] = myWindy;
                            //    newItem[@"Yellow"] = myYellow;
                            
                            
                            [newItem saveInBackground];
                            
                            
                        }
                    } else {
                        // Log details of the failure
                        NSLog(@"Error getting default closet: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error getting user closet: %@ %@", error, [error userInfo]);
        }
    }]; // end of getting custom closet per logged in user. chh 04092014
    
}


-(void)createCustomCloset2{
    //(void)someMethodWithValue:(SomeType)value;
    // Here we check to see if the user has closet items. chh 03162014
    
    //NSLog(@"got here");
    PFUser *currUser = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Closet"];
    
    [query whereKey:@"User" equalTo: currUser];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu objects in create custom closet.", (unsigned long)objects.count);
            // Do something with the found objects
            
            if (objects.count == 0) {
                NSLog(@"No objects in closet. Filling Closet.");
                PFQuery *defaultquery = [PFQuery queryWithClassName:@"DefaultCloset"];
                [defaultquery findObjectsInBackgroundWithBlock:^(NSArray *defaultobjects, NSError *error) {
                    
                    
                    if (!error) {
                        NSLog(@".....More Filling Closet.");
                        // The find succeeded.
                        //   NSLog(@"Successfully retrieved %d objects.", defaultobjects.count);
                        // Do something with the found objects
                        for (PFObject *object in defaultobjects) {
                            //      NSLog(@"copying default object to custom object id %@", object.objectId);
                            //  NSLog(@"my object in copy contains: %@", object);
                            
                            
                            //  Next section is all about copying the default closet into the users closet one item at a time.  chh 03152014
                            
                            //       NSNumber *myBlack = [object objectForKey:@"Black"];
                            
                            //  NSLog(@"my black value in copy contains: %@", myBlack);
                            //
                            //       NSNumber *myBlue = [object objectForKey:@"Blue"];
                            NSNumber *myFrigid = [object objectForKey:@"Frigid"];
                            NSNumber *myCold = [object objectForKey:@"Cold"];
                            NSString *myDescription = object[@"Description"];
                            PFFile *myImage = [object objectForKey:@"Image"];
                            
                            //    NSLog(@"my image value in copy contains: %@", myImage);
                            
                            NSNumber *myGender = [object objectForKey:@"Gender"];
                            //        NSNumber *myGreen = [object objectForKey:@"Green"];
                            NSNumber *myHot = [object objectForKey:@"Hot"];
                            
                            
                            NSString *myLabel = object[@"Label"];
                            NSNumber *myMild = [object objectForKey:@"Mild"];
                            //         NSNumber *myOrange = [object objectForKey:@"Orange"];
                            //        NSNumber *myPurple = [object objectForKey:@"Purple"];
                            NSNumber *myBrisk = [object objectForKey:@"Brisk"];
                            
                            NSNumber *myRating = [object objectForKey:@"Rating"];
                            //   NSNumber *myRed = [object objectForKey:@"Red"];
                            NSNumber *myStatus = [object objectForKey:@"Status"];
                            NSNumber *mySizzling = [object objectForKey:@"Sizzling"];
                            
                            //   NSNumber *myTempMax = [object objectForKey:@"TempMax"];
                            //  NSNumber *myTempMin = [object objectForKey:@"TempMin"];
                            NSNumber *myTypeID = [object objectForKey:@"TypeID"];
                            
                            
                            //    NSNumber *myWhite = [object objectForKey:@"White"];
                            NSNumber *myWindy = [object objectForKey:@"Windy"];
                            //    NSNumber *myYellow = [object objectForKey:@"Yellow"];
                            
                            
                            //PFUser *user = [PFUser currentUser];
                            PFObject *newItem = [PFObject objectWithClassName:@"Closet"];
                            
                            newItem[@"User"] = currUser;
                            
                            
                            //      newItem[@"Black"] = myBlack;
                            //      newItem[@"Blue"] = myBlue;
                            newItem[@"Frigid"] = myFrigid;
                            newItem[@"Cold"] = myCold;
                            newItem[@"Description"] = myDescription;
                            newItem[@"Image"] = myImage;
                            newItem[@"Gender"] = myGender;
                            //    newItem[@"Green"] = myGreen;
                            newItem[@"Hot"] = myHot;
                            newItem[@"Label"] = myLabel;
                            newItem[@"Mild"] = myMild;
                            //    newItem[@"Orange"] = myOrange;
                            //    newItem[@"Purple"] = myPurple;
                            newItem[@"Brisk"] = myBrisk;
                            newItem[@"Rating"] = myRating;
                            //    newItem[@"Red"] = myRed;
                            newItem[@"Status"] = myStatus;
                            newItem[@"Sizzling"] = mySizzling;
                            //    newItem[@"TempMax"] = myTempMax;
                            //   newItem[@"TempMin"] = myTempMin;
                            newItem[@"TypeID"] = myTypeID;
                            //    newItem[@"White"] = myWhite;
                            newItem[@"Windy"] = myWindy;
                            //    newItem[@"Yellow"] = myYellow;
                            
                            
                            [newItem saveInBackground];
                            
                            
                            
                            
                            
                        }
                    } else {
                        // Log details of the failure
                        NSLog(@"Error getting default closet: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error getting user closet: %@ %@", error, [error userInfo]);
        }
    }]; // end of getting custom closet per logged in user. chh 04092014
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //   [self.parentViewController.tabBarController setSelectedIndex:0];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //   cdkMainViewController *viewController = [[cdkMainViewController alloc] init];
    //  [self presentViewController:viewController animated:YES completion:nil];
    
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


- (IBAction)myResetClosetButton:(id)sender {
  /*  UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Reset Closet"];
    [alert setMessage:@"Are you sure you want to reset?"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert show];
    */
    
}
@end
