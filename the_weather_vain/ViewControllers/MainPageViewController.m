//
//  MainPageViewController.m
//  WeatherVain
//
//  Created by Tehreem Syed on 3/3/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import "MainPageViewController.h"
#import "WXWeatherViewController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import <Parse/Parse.h>

@interface MainPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic) NSInteger currentViewController;
@end


@implementation MainPageViewController

@synthesize modelArray;
@synthesize pageViewController;

#pragma mark - UIPageViewControllerDataSource Methods

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return 2;
}

-(NSInteger) presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    
    return self.currentViewController;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.modelArray indexOfObject:[(WXWeatherViewController *)viewController label]];

    if(currentIndex == 0)
    {
        return nil;
    }
    
    WXWeatherViewController *weatherViewController = [[WXWeatherViewController alloc] init];
    weatherViewController.label = [self.modelArray objectAtIndex:currentIndex - 1];
    
    self.currentViewController = currentIndex;

    
    return weatherViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.modelArray indexOfObject:[(WXWeatherViewController *)viewController label]];

    if(currentIndex == self.modelArray.count-1)
    {
        return nil;
    }
    
    WXWeatherViewController *weatherViewController = [[WXWeatherViewController alloc] init];
    weatherViewController.label = [self.modelArray objectAtIndex:currentIndex+1];
    
    self.currentViewController = currentIndex;
    
    return weatherViewController;
}

#pragma mark - UIPageViewControllerDelegate Methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        //Set the array with only 1 view controller
        UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        //Important- Set the doubleSided property to NO.
        self.pageViewController.doubleSided = NO;
        //Return the spine location
        return UIPageViewControllerSpineLocationMin;
    }
    else
    {
        NSArray *viewControllers = nil;
        WXWeatherViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
        
        NSUInteger currentIndex = [self.modelArray indexOfObject:[(WXWeatherViewController *)currentViewController label]];
        
        if(currentIndex == 0 || currentIndex %2 == 0)
        {
            UIViewController *nextViewController = [self pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
            viewControllers = [NSArray arrayWithObjects:currentViewController, nextViewController, nil];
        }
        else
        {
            UIViewController *previousViewController = [self pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
            viewControllers = [NSArray arrayWithObjects:previousViewController, currentViewController, nil];
        }
        //Now, set the viewControllers property of UIPageViewController
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        return UIPageViewControllerSpineLocationMid;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (![PFUser currentUser]) { // No user logged in
        NSLog(@"current user %@", [PFUser currentUser]);
        
        // show log in screen
        
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
        // continue with a the current code
        
        NSLog(@"current user %@", [PFUser currentUser]);
        // Here we check to see if the user has closet items. chh 03162014
        

    
//    UIImage *background = [UIImage imageNamed: @"outfit-1_Fotor"];
    
    //3
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 1.0;
    [self.blurredImageView setImageToBlur:self.bg_image blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    //Instantiate the model array
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int index = 1; index <= 2 ; index++)
    {
        [array addObject:[NSString stringWithFormat:@"Page %d",index]];
    }
    
    self.modelArray = [NSArray arrayWithArray:array];
    
    //Step 1
    //Instantiate the UIPageViewController.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
       
    //Step 2:
    //Assign the delegate and datasource as self.
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;

    //Step 3:
    //Set the initial view controllers.
    WXWeatherViewController *weatherViewController = [[WXWeatherViewController alloc] init];
//    weatherViewController.label = @"Page 1";

    
    NSArray *viewControllers = [NSArray arrayWithObject:weatherViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    //Step 4:
    //ViewController containment steps
    //Add the pageViewController as the childViewController
    [self addChildViewController:self.pageViewController];
    
    //Add the view of the pageViewController to the current view
    [self.view addSubview:self.pageViewController.view];
    
    //Call didMoveToParentViewController: of the childViewController, the UIPageViewController instance in our case.
    [self.pageViewController didMoveToParentViewController:self];
    
    //Step 5:
    // set the pageViewController's frame as an inset rect.
//    CGRect pageViewRect = self.view.bounds;
//    pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
//    self.pageViewController.view.frame = pageViewRect;
    
    //Step 6:
    //Assign the gestureRecognizers property of our pageViewController to our view's gestureRecognizers property.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
        
    } // end of if user not log in. chh 04212014
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) viewWillLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    self.blurredImageView.frame = bounds;
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




@end
