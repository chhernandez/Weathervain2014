//
//  WXControllerViewController.m
//  WeatherVain
//
//  Copyright (c) 2014 CodeKite. All rights reserved.
//
//
//  Objective: Home Screen
//  --> weather, location, outfit
//

#import "WXController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "WXManager.h"
#import "MainPageViewController.h"
#import <FontAwesomeKit/FAKFontAwesome.h>
#import <Parse/Parse.h>
#import "WVTabBarViewController.h"


NSInteger currentTemp;
NSString *tempTag;
NSString *closetName;
BOOL retValue;

@interface WXController ()<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
typedef void(^closetCompletionBlock)(BOOL);
typedef void (^checkEmptyBlock)(BOOL);
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) IBOutlet UIButton *fullScreenButton;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) PFLogInViewController *logInViewController;
@end

@implementation WXController

NSUserDefaults *standardDefaults;


- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void) pushToDetail:(id) sender{
    MainPageViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainPageView"];
    
    [self presentViewController:viewController animated:YES completion:nil];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    
    
    if ([PFUser currentUser]) {
        

    NSLog(@">>>>>>>>>>>> I'M HERE.");
    PFUser *userName =[PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Closet"];
    [query whereKey:@"User" equalTo: userName];
    NSLog(@">>>>>>>>>>>> I'M HEERREEEEEEEE.");
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            NSLog(@">>>>>>>>>>>> User is registered.");
            if (objects.count == 0) {
                retValue = true;
                NSLog(@">>>>>>>>>>>> There's nothing in the closet so it should return true.");
                closetName = @"DefaultCloset";
                
                NSLog(@"IT'S EMPTY SO GOING TO OUTFIT WITH DEFAULT.");
                [self createCustomCloset];
                [self outfitSuggestionAlgorithm];
            }
            else{
                retValue = false;
                NSLog(@">>>>>>>>>>>> but it's returning false.");
                closetName = @"Closet";
                NSLog(@"IT'S NOT EMPTY SO GOING TO OUTFIT WITH CLOSET.");
                [self outfitSuggestionAlgorithm];
            }
            //  return false;
        }
    }];
    
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // custom navigation bar image for main outfit selection page
    // that takes into account for retina display as well as regular display
    
    /****custom navigation background****/
    UINavigationBar *home_NavBar = [self.navigationController navigationBar];
    UIImage *img = [UIImage imageNamed:@"navigationBG.png"];
    [home_NavBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
   
    
  //  [[UILabel appearance] setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:18.0]];

    
    // MAKE SURE USER IS LOGGED IN
    
    if (![PFUser currentUser]) { // No user logged in
        NSLog(@"current user %@", [PFUser currentUser]);
                // show log in screen
        
        //create and show the login/signup view. chh
        
        // Create the log in view controller
    
        self.logInViewController = [[PFLogInViewController alloc] init];
        
        [self.logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        
        [self.logInViewController.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wvlogo.png"]]];
        
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        
        [signUpViewController.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wvlogo.png"]]];
        
        // Assign our sign up controller to be displayed from the login controller
        [self.logInViewController setSignUpController:signUpViewController];
        
        
        // Present the log in view controller
        [self presentViewController:self.logInViewController animated:YES completion:NULL];
        
        
    } else {
        // continue with a the current code
        
        NSLog(@"current user %@", [PFUser currentUser]);
        // Here we check to see if the user has closet items. chh 03162014
        
  
        
    }// end of if user not logged in. chh 04212014
    
    
    // sets up closet

    
    
    
    self.screenHeight = [UIScreen mainScreen].bounds.size.height - self.tabBarController.view.frame.size.height -  150;
    
    
   
    
    [self printWeatherToHomeScreen];
    
    
}

/*******************************************************/
/*******************************************************/
/*******************************************************/
// HELPER METHOD: averageTemp
// gets average temperature over a number of hours
// return: tag that matches average temp
/*******************************************************/
/*******************************************************/
/*******************************************************/
- (void)averageTemp
{

    
    
}

/*******************************************************/
/*******************************************************/
/*******************************************************/
// METHOD: outfitSuggestionAlgorithm
// Suggests outfit based on weather, ratings
/*******************************************************/
/*******************************************************/
/*******************************************************/
- (void)outfitSuggestionAlgorithm{
{

    PFUser *currUser = [PFUser currentUser];

    // gets temperature
    NSLog(@"*******CURRENT TEMPERATURE %ld", (long)currentTemp);
    
    // gets tag for temperature
    if(currentTemp == 0)
        tempTag = @"Hot";
    else if(0 < currentTemp && currentTemp <= 40)
        tempTag = @"Frigid";
    else if(40 < currentTemp && currentTemp <= 50)
        tempTag = @"Cold";
    else if(50 < currentTemp && currentTemp <= 60)
        tempTag = @"Brisk";
    else if(60 < currentTemp && currentTemp <= 68)
        tempTag = @"Mild";
    else if(68 < currentTemp && currentTemp <= 75)
        tempTag = @"Warm";
    else if(75 < currentTemp && currentTemp <= 87)
        tempTag = @"Hot";
    else
        tempTag = @"Sizzling";
    NSLog(@"*******TAG %@", tempTag);
    
    [self getTopsForUser:currUser];
    NSString *image_name = [NSString stringWithFormat:@"%@Button",tempTag.lowercaseString];
    [self.myWeatherTag1 setImage:[UIImage imageNamed:image_name]];
    
    
}
}

/*******************************************************/
/*******************************************************/
/*******************************************************/
// HELPER METHOD: getsTopsForUser
/*******************************************************/
/*******************************************************/
/*******************************************************/
-(void) getTopsForUser:(PFUser *) currUser{
    //*******************  TOPS
    // sets up parse
    PFQuery *query = [PFQuery queryWithClassName: closetName];
    NSMutableArray *topsArray;
    topsArray = [NSMutableArray arrayWithObjects: nil];
    
    if([closetName isEqualToString:@"Closet"]){
        [query whereKey:@"User" equalTo:currUser];
    }
    
    [query whereKey:@"TypeID" equalTo:@1];
    [query whereKey:tempTag equalTo:@1];

    [query whereKey:@"Gender" equalTo:currUser[@"gender"]];

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *tops, NSError *error) {
        
        if (!error) {
            int i = 0;
            for (PFObject *top in tops) {
                //NSNumber *rating = [top.fetch objectForKey:@"Rating"];
                //  NSString Label = top.Label;
                // get each value and store ID in array for rating number
                //int rating = [[top valueForKey:@"Rating"] intValue];
                int rating = [[top valueForKey:@"Rating" ] intValue];
                
                //NSString *topLabel = [top valueForKey:@"Label"];
                //NSLog(@"tops label: %@", topLabel);
                //NSLog(@"tops rating: %d", rating);
                for(i=0; i<rating; i++){
                    // add to array
                    [topsArray addObject: top];
                }
            
                
            }
            // pick value from topsArray randomly
            uint32_t rnd = arc4random_uniform([topsArray count]);
            NSObject *randomTop = [topsArray objectAtIndex:rnd];
            NSString *topLabel = [randomTop valueForKey:@"Label"];
            NSLog(@"chosen top: %@", topLabel);
            
            // ***** PRINT IMAGE TO SCREEN
            PFFile *imageFile = [randomTop valueForKey:@"Image"];
            UIImage *image = [UIImage imageWithData:[imageFile getData]];
            [self.Tops setImage:image];
            
        } else {
            // Log details of the failure
            NSLog(@"Error with query: %@ %@", error, [error userInfo]);
        }
        [self getBottomsForUser:currUser];
    }];

}

-(void) getBottomsForUser:(PFUser *) currUser{
    //*******************  BOTTOMS
    NSMutableArray *bottomsArray;
    bottomsArray = [NSMutableArray arrayWithObjects: nil];
    
    PFQuery *queryBottom = [PFQuery queryWithClassName:closetName];
    
    if([closetName isEqualToString:@"Closet"]){
        [queryBottom whereKey:@"User" equalTo:currUser];
    }
    
    [queryBottom whereKey:@"TypeID" equalTo:@2];
    [queryBottom whereKey:tempTag equalTo:@1];
    [queryBottom whereKey:@"Gender" equalTo:currUser[@"gender"]];
    
    [queryBottom findObjectsInBackgroundWithBlock:^(NSArray *bottoms, NSError *error) {
        
        if (!error) {
            int j = 0;
            for (PFObject *bottom in bottoms) {
                // accounts for rating system
                int rating = [[bottom valueForKey:@"Rating" ] intValue];
                for(j=0; j<rating; j++){
                    [bottomsArray addObject: bottom];
                }
            }
            
            // pick bottom randomly
            uint32_t rnd1 = arc4random_uniform([bottomsArray count]);
            NSObject *randomBottom = [bottomsArray objectAtIndex:rnd1];
            NSString *bottomLabel = [randomBottom valueForKey:@"Label"];
            NSLog(@"chosen bottom: %@", bottomLabel);
            
            // ***** PRINT IMAGE TO SCREEN
            // ***** PRINT IMAGE TO SCREEN
            PFFile *imageFile = [randomBottom valueForKey:@"Image"];
            UIImage *image = [UIImage imageWithData:[imageFile getData]];
            [self.Bottoms setImage:image];
            
        } else {
            // Log details of the failure
            NSLog(@"Error with query: %@ %@", error, [error userInfo]);
        }
        [self getOuterNAccessaryForUser:currUser];
    }];
    
    

}

-(void) getOuterNAccessaryForUser:(PFUser *) currUser{
    //*******************  OUTWEAR OR ACCESSORY
    // sets up parse
    
    


    PFQuery *queryOuterwear = [PFQuery queryWithClassName: closetName];
    NSMutableArray *outerwearArray;
    outerwearArray = [NSMutableArray arrayWithObjects: nil];
    
    
//    [queryOuterwear whereKey:@"User" equalTo:currUser];
    // suggests outerwear if cold, otherwise suggest accessory
    if([closetName isEqualToString:@"Closet"]){
        [queryOuterwear whereKey:@"User" equalTo:currUser];
    }
    
    if([tempTag isEqualToString:@"Frigid"] || [tempTag isEqualToString:@"Cold"] || [tempTag isEqualToString:@"Brisk"]){
        [queryOuterwear whereKey:@"TypeID" equalTo:@4];
    }
    else
        [queryOuterwear whereKey:@"TypeID" equalTo:@5];
    
    [queryOuterwear whereKey:tempTag equalTo:@1];
    [queryOuterwear whereKey:@"Gender" equalTo:currUser[@"gender"]];
    
    [queryOuterwear findObjectsInBackgroundWithBlock:^(NSArray *outerwears, NSError *error) {
        if (!error) {
            int k = 0;
            for (PFObject *outerwear in outerwears) {
                // accounts for rating system
                int rating = [[outerwear valueForKey:@"Rating" ] intValue];
                for(k=0; k<rating; k++){
                    [outerwearArray addObject: outerwear];
                }
            }
            
            // pick clothing randomly
            uint32_t rnd3 = arc4random_uniform([outerwearArray count]);
            NSObject *randomOuterwear = [outerwearArray objectAtIndex:rnd3];
            NSString *outerwearLabel = [randomOuterwear valueForKey:@"Label"];
            NSLog(@"chosen outerwear: %@", outerwearLabel);
            
            // ***** PRINT IMAGE TO SCREEN
            PFFile *imageFile = [randomOuterwear valueForKey:@"Image"];
            UIImage *image = [UIImage imageWithData:[imageFile getData]];
            [self.Accessories setImage:image];
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error with query: %@ %@", error, [error userInfo]);
        }
        [self getShoesForUsers:currUser];
    }];

    
}

-(void) getShoesForUsers:(PFUser *) currUser{
    //*******************  SHOES
    // sets up parse
    NSMutableArray *shoesArray;
    shoesArray = [NSMutableArray arrayWithObjects: nil];
    
    PFQuery *queryShoes = [PFQuery queryWithClassName: closetName];
    
    if([closetName isEqualToString:@"Closet"]){
        [queryShoes whereKey:@"User" equalTo:currUser];
    }
    

    [queryShoes whereKey:@"TypeID" equalTo:@3];
    [queryShoes whereKey:tempTag equalTo:@1];
    [queryShoes whereKey:@"Gender" equalTo:currUser[@"gender"]];


    
    [queryShoes findObjectsInBackgroundWithBlock:^(NSArray *shoes, NSError *error) {
        
        if (!error) {
            int l = 0;
            for (PFObject *shoe in shoes) {
                // accounts for rating system
                int rating = [[shoe valueForKey:@"Rating" ] intValue];
                for(l=0; l<rating; l++){
                    [shoesArray addObject: shoe];
                }
            }
            
            // pick shoes randomly of the ones possible
            uint32_t rnd2 = arc4random_uniform([shoesArray count]);
            NSObject *randomShoe = [shoesArray objectAtIndex:rnd2];
            NSString *shoeLabel = [randomShoe valueForKey:@"Label"];
            
            // ***** if raining, wear rain boots
            
            NSLog(@"chosen shoe: %@", shoeLabel);
            
            // ***** PRINT IMAGE TO SCREEN
            PFFile *imageFile = [randomShoe valueForKey:@"Image"];
            UIImage *image = [UIImage imageWithData:[imageFile getData]];
            [self.Shoes setImage:image];
            
            UIGraphicsBeginImageContext(self.view.window.bounds.size);
            [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *bg = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            WVTabBarViewController *tabBar = (WVTabBarViewController *) self.tabBarController;
            tabBar.bg_image = bg;
            
        } else {
            // Log details of the failure
            NSLog(@"Error with query: %@ %@", error, [error userInfo]);
        }
    }];

}
/*******************************************************/
/*******************************************************/
/*******************************************************/
// METHOD: printWeatherToHomeScreen
// Prints weather, location to home screen
/*******************************************************/
/*******************************************************/
/*******************************************************/
- (void)printWeatherToHomeScreen{
    

    
    
    // my code
    CGRect weatherFrame;
    weatherFrame.size.height = 189;
    CGFloat inset = 5;
    //FGFloat temperatureHeight =
    
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    
    headerFrame.size.height = headerFrame.size.height - 500;
    //    headerFrame.size.height = self.view.frame.size.height - self.tabBarController.view.frame.size.height;
    //2
    //an inset (or padding) variable so that all labels are evenly spaced and centered.
    //CGFloat inset = 5;
    //3
    CGFloat temperatureHeight = 50;
    CGFloat hiloHeight = 20;
    CGFloat iconHeight = 30;
    
    
    //4
    CGRect hiloFrame = CGRectMake(inset, headerFrame.size.height - hiloHeight , headerFrame.size.width -(2*inset), hiloHeight);
    
    CGRect temperatureFrame = CGRectMake(inset, headerFrame.size.height - (temperatureHeight + hiloHeight), headerFrame.size.width - (2 *inset), temperatureHeight);
    
    CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y - iconHeight, iconHeight, iconHeight);
    
    //CGRect umbFrame = CGRectMake(inset, temperatureFrame.origin.y - iconHeight, iconHeight, iconHeight);
    //5
    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight));
    //    conditionsFrame.origin.x =  iconFrame.origin.x + (iconHeight + 10);
    conditionsFrame.origin.x = inset;
    conditionsFrame.origin.y = iconFrame.origin.y + iconFrame.size.height - 200;
    
    
    
    
    UIView *header = [[ UIView alloc] initWithFrame:headerFrame];
    
    
    // temperature
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.text = @"0°";
    temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30]; //120
    //[header addSubview:temperatureLabel];
    
  // carlos code to display temperature.
    
    self.myWeatherTemp.backgroundColor = [UIColor clearColor];
    self.myWeatherTemp.textColor = [UIColor whiteColor];
    self.myWeatherTemp.text = @"0°";
  //  self.myWeatherTemp.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    
    // high & low
    UILabel *hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    hiloLabel.backgroundColor = [UIColor clearColor];
    hiloLabel.textColor = [UIColor whiteColor];
    hiloLabel.text = @"0° / 0°";
    hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];//28
    //[header addSubview:hiloLabel];
    
    
    
    // city
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @"Loading...";
    cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    //[header addSubview:cityLabel];
    
    // condition
    UILabel *conditionsLabel = [[UILabel alloc] initWithFrame: conditionsFrame];
    conditionsLabel.backgroundColor = [UIColor clearColor];
    conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    conditionsLabel.textColor = [UIColor whiteColor];
    conditionsLabel.text = @"Clear";
   // [header addSubview:conditionsLabel];
    
    self.frigidArray = @[@"Brrr, so cold I can barely move! Time to find a coat",
                         @"Is that a polar bear wearing a coat outside? Yes.",
                         @"It’s a winter wonderland out there. Time for hot cocoa.",
                         @"If you love the Arctic you will surely enjoy this day!",
                         @"You can look fashionable without resembling an eskimo."];
    
    self.coldArray = @[@"You could stay in bed, or you could wear your favorite sweater.",
                       @"Those boots are made for walking to the nearest coffee shop.",
                       @"A book, a cup of tea and your favorite outfit. A match made in heaven.",
                       @"This weather is the perfect excuse to wear mittens. Check your pockets.",
                       @"Time to showcase your crazy socks collection."];
    
    self.briskArray = @[@"1) Perfect weather to go for a run! Don’t forget your hoodie.",
                        
                        @"Strolling inside your favorite store sounds like a great idea.",
                        
                        @"Red noses can be cute too. They match your lip balm perfectly.",
                        
                        @"Grab your favorite blanket and have a picnic in the park.",
                        
                        @"Your new jacket would look amazing in this weather."];
    
    self.mildArray = @[@"Did you know there’s a park nearby? Time to explore the outdoors!",
                       @"No need to bring your sweater today!",
                       @"That dog needs to be walked...No dog? No problem!",
                       @"Consider riding your bicycle today. This is the perfect weather!",
                       @"You can finally stop wearing socks!"
                       ];
    
    self.warmArray = @[@"Your flip flops are inside your closet somewhere.",
                       
                       @"That cold drink definitely matches your outfit!",
                       
                       @"Short sleeves and your hat are a must today.",
                       
                       @"Today might be the perfect weather.",
                       
                       @"Time to start ordering iced coffee!"
                       
                       ];
    
    self.hotArray = @[@"Pants are a no-no today!",
                      
                      @"Darling, it’s hot outside! Time to turn on some fans.",
                      
                      @"A pool will come in handy today.",
                      
                      @"Bikinis are the new suit. Just don’t wear them to work!",
                      
                      @"Sandal season has officially begun!"
                      
                      ];
    
    self.sizzlingArray = @[@"It’s raining flames and hot dogs!",
                           
                           @"Don’t forget your shades today. It’s so bright it’s blinding!",
                           
                           @"I know it’s tempting, but you still need to wear clothes.",
                           
                           @"Now you know why hippos love the water.",
                           
                           @"Sunblock is your best friend today."
                           
                           ];
    
    // created array for each temperature for later use. chh 05082014
    uint32_t rndCold = arc4random_uniform([self.coldArray count]);
    NSString *randomCold = [self.coldArray objectAtIndex:rndCold];
    
    uint32_t rndBrisk = arc4random_uniform([self.briskArray count]);
    NSString *randomBrisk = [self.briskArray objectAtIndex:rndBrisk];
    
    uint32_t rndMild = arc4random_uniform([self.mildArray count]);
    NSString *randomMild = [self.mildArray objectAtIndex:rndMild];
    
    uint32_t rndHot = arc4random_uniform([self.hotArray count]);
    NSString *randomHot = [self.hotArray objectAtIndex:rndHot];
    
    uint32_t rndSizzling = arc4random_uniform([self.sizzlingArray count]);
    NSString *randomSizzling = [self.sizzlingArray objectAtIndex:rndSizzling];
    uint32_t rndFrigid = arc4random_uniform([self.frigidArray count]);
    NSString *randomFrigid = [self.frigidArray objectAtIndex:rndFrigid];
    
    uint32_t rndWarm = arc4random_uniform([self.warmArray count]);
    NSString *randomWarm = [self.warmArray objectAtIndex:rndWarm];
    
    
    self.myWeatherDescription.backgroundColor = [UIColor clearColor];
  //  self.myWeatherDescription.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.myWeatherDescription.textColor = [UIColor whiteColor];
    self.myWeatherDescription.text = randomWarm;
    
    
    // 1
    /*Observes the currentCondition key on the WXManager singleton.
     */
    [[RACObserve([WXManager sharedManager], currentCondition)
      // 2
      /*Delivers any changes on the main thread since you’re updating the UI.*/
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(WXCondition *newCondition) {
         // 3
         /*Updates the text labels with weather data; you’re using newCondition for the text and not the singleton. The subscriber parameter is guaranteed to be the new value.*/
         
         temperatureLabel.text = [NSString stringWithFormat:@"%.0f°",newCondition.temperature.floatValue];
         
         // carlos added code for temperature text.
         self.myWeatherTemp.text = [NSString stringWithFormat:@"%.0f°",newCondition.temperature.floatValue];
         // to change the custom font size. chh 05012014
         self.myWeatherTemp.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:18];
         
         self.myWeatherIcon.clipsToBounds = YES;
         
         self.myWeatherIcon.image = [UIImage imageNamed:[newCondition imageName]];
         [self.myWeatherTag2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Button", newCondition.condition.lowercaseString]]];
         conditionsLabel.text = [newCondition.condition capitalizedString];
         
         cityLabel.text = [newCondition.locationName capitalizedString];

         
         //********************************* saves temp and calls algorithm method
         currentTemp = newCondition.temperature.floatValue;
         
         
        
     }];
    // 1
    /*The RAC(…) macro helps keep syntax clean. The returned value from the signal is assigned to the text key of the hiloLabel object.
     */
    RAC(hiloLabel, text) = [[RACSignal combineLatest:@[
                                                       // 2
                                                       /*Observe the high and low temperatures of the currentCondition key. Combine the signals and use the latest values for both. The signal fires when either key changes.*/
                                                       RACObserve([WXManager sharedManager], currentCondition.tempHigh),
                                                       RACObserve([WXManager sharedManager], currentCondition.tempLow)]
                             // 3
                             /*Reduce the values from your combined signals into a single value; note that the parameter order matches the order of your signals.*/
                                              reduce:^(NSNumber *hi, NSNumber *low) {
                                                  return [NSString  stringWithFormat:@"%.0f° / %.0f°",hi.floatValue,low.floatValue];
                                              }]
                            // 4->delivering back to the main thread
                            deliverOn:RACScheduler.mainThreadScheduler];
    
    [[WXManager sharedManager] findCurrentLocation];
    //    [ProgressHUD show:@"Getting Weather data"];
    [[RACObserve([WXManager sharedManager], hourlyForecast)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newForecast) {
         //         [ProgressHUD showSuccess:@"Done"];
         //         [self.tableView reloadData];
     }];
    
    [[RACObserve([WXManager sharedManager], dailyForecast)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newForecast) {
         //         [self.tableView reloadData];
     }];
    
    [self.view addSubview:header];
    [self.view addSubview:self.fullScreenButton];
    
}






- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    bounds.size.height = bounds.size.height - 50;
    self.backgroundImageView.frame = bounds;
    //    self.blurredImageView.frame = bounds;
    //    self.fullScreenButton.frame = bounds;
}






#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 1
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    // 2
    CGFloat percent = MIN(position / height, 1.0);
    // 3
    self.blurredImageView.alpha = percent;
}




#pragma mark - PFLogInViewControllerDelegate




// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
    {
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
    
    //   [self.parentViewController.tabBarController setSelectedIndex:0];
    
    // Present the log in view controller
    [self.logInViewController dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:self.logInViewController animated:YES completion:NULL];
    }];
    
  //  [self.navigationController popToRootViewControllerAnimated:YES];
    
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
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self linkFacebookLoginToParseUser:user];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
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



-(BOOL)checkIfEmptyCloset:(PFUser*) currUser{
    //(void)someMethodWithValue:(SomeType)value;
    // Here we check to see if the user has closet items. chh 03162014
    //retValue = false;
    
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
 
            NSLog(@"Error getting user closet: %@ %@", error, [error userInfo]);
        }
    }]; // end of getting custom closet per logged in user. chh 04092014
    return retValue;
}


-(void)createCustomCloset{
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



@end