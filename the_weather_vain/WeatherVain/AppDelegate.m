//
//  AppDelegate.m
//  WeatherVain
//
//  Created by Tehreem Syed on 2/8/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import "AppDelegate.h"
#import "WXController.h"
#import <TSMessage.h>
#import <Parse/Parse.h>
#import "WXWeatherViewController.h"
#import "RKClient.h"
#import "WXManager.h"


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse setApplicationId:@"2u19gzNOrLZzNpjjGbxsrm0N7Zi2vc0GjmcjMz0F"
                  clientKey:@"MUw1snf6QWujtUYz6Ih0ndSo4RYZzSLn5GfNpd97"];
    
    [[PFUser currentUser] refresh];
    [PFFacebookUtils initializeFacebook];
    
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
//        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    self.tabBarController = (UITabBarController *) self.window.rootViewController;
    self.tabBarController.selectedIndex = 0;
    
    
    
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"RobotoCondensed-Light" size:21]
       }
     forState:UIControlStateNormal];
    
    
    
    /*

    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor greenColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:20.0f],
                                                            
      }];*/
    
    // sets custom background for tab bar
    //UITabBar *tabBar = [UITabBar appearance]; [tabBar setBackgroundImage:[UIImage imageNamed:@"tabBG" ]];
    
//    [[RKClient sharedInstance] getDailyForecastWithParameters:@{@"lat": @"37.785834",
//                                                                @"lon":@"-122.406417",
//                                                                @"units":@"imperial",
//                                                                @"cnt":@"7",
//                                                                @"APPID":@"9742f7e9daccd05446b688480c6b0c7a"}
//                                                  withSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                                      NSLog(@"MappingResult: %@", mappingResult);
//                                                  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                                                      NSLog(@"Error: %@", error);
//                                                  }];
//    
//    [[RKClient sharedInstance] getHourlyForecastWithParameters:@{@"lat": @"37.785834",
//                                                                @"lon":@"-122.406417",
//                                                                @"units":@"imperial",
//                                                                @"cnt":@"7",
//                                                                @"APPID":@"9742f7e9daccd05446b688480c6b0c7a"}
//                                                  withSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                                      NSLog(@"MappingResult: %@", mappingResult);
//                                                  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                                                      NSLog(@"Error: %@", error);
//                                                  }];
//    
    
//
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    //1
//    self.window.rootViewController = [WXController new];
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//    //2
//    [TSMessage setDefaultViewController: self.window.rootViewController];
    
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    

    return YES;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Fetch started");
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    // Get Current Location from NSUserDefaults
    CLLocationCoordinate2D currentLocation;
    currentLocation.latitude = [standardDefaults floatForKey:@"locationLatitude"];
    currentLocation.longitude = [standardDefaults floatForKey:@"locationLongitude"];
    
    // GetWeather for current location
    
    
    // Set up Local Notifications
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    [[RACObserve([WXManager sharedManager], currentCondition)
      // 2
      /*Delivers any changes on the main thread since you’re updating the UI.*/
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(WXCondition *newCondition) {
         
         
         completionHandler(UIBackgroundFetchResultNewData);
         NSLog(@"Fetch completed");

     }];
    
    
    }



-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return true;
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WeatherVain" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WeatherVain.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
