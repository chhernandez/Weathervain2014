//
//  WVTabBarViewController.m
//  WeatherVain
//
//  Created by Tehreem Syed on 4/8/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import "WVTabBarViewController.h"
#import "WVCameraViewController.h"
#import "cdkMoreTableViewController.h"
#import "ProfileViewController.h"
#import "cdkMainViewController.h"
#import <FontAwesomeKit/FAKIonIcons.h>
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "WXWeatherViewController.h"

@interface WVTabBarViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITabBarControllerDelegate>
@property BOOL newMedia;

@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;
@end

@implementation WVTabBarViewController


@synthesize fileUploadBackgroundTaskId;
@synthesize photoPostBackgroundTaskId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.delegate = self;
    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    FAKIcon *homeIcon = [FAKFontAwesome homeIconWithSize:35.0f];
//    FAKIcon *weatherIcon = [FAKIonIcons ios7PartlysunnyOutlineIconWithSize:35.0f];
//    FAKIcon *cameraIcon = [FAKIonIcons ios7CameraOutlineIconWithSize:35.0f];
//    FAKIcon *profileIcon = [FAKIonIcons ios7PersonOutlineIconWithSize:35.0f];
//    FAKIcon *settingsIcon = [FAKIonIcons ios7GearOutlineIconWithSize:35.0f];
//    
//    for (UITabBarItem *item in self.tabBar.items) {
//        if ([item.title isEqualToString:@"Home"]) {
//            [item setImage:[homeIcon imageWithSize:CGSizeMake(35, 35)]];
//        } else if ([item.title isEqualToString:@"Weather"]) {
//            [item setImage:[weatherIcon imageWithSize:CGSizeMake(35, 35)]];
//        } else if ([item.title isEqualToString:@"Camera"]) {
//            [item setImage:[cameraIcon imageWithSize:CGSizeMake(35, 35)]];
//        } else if ([item.title isEqualToString:@"Profile"]) {
//            [item setImage:[profileIcon imageWithSize:CGSizeMake(35, 35)]];
//        } else if ([item.title isEqualToString:@"More"]) {
//            [item setImage:[settingsIcon imageWithSize:CGSizeMake(35, 35)]];
//        }
//    }
//    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
   
    if (![PFUser currentUser]) {
        if ([viewController isKindOfClass:[WVCameraViewController class]] || [viewController isKindOfClass:[ProfileViewController class]]) {
            
            cdkMainViewController *viewController = [[cdkMainViewController alloc] init];
            [self presentViewController:viewController animated:YES completion:nil];
            
            return NO;
        }
    }
    
    else if([viewController isKindOfClass:[WXWeatherViewController class]])
    {
       
        
        WXWeatherViewController * mainPageViewController = (WXWeatherViewController *) viewController;
        mainPageViewController.bg_image = self.bg_image;
        
    }

    
    return YES;
}
// Carlos code to get the view controller to display root view. chh 04252014

// ******************* this next code makes all tab controllers go to the pop root controller for each one  chh 04252014    ******************

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSArray *array = [tabBarController viewControllers];
    if([[array objectAtIndex:tabBarController.selectedIndex] isKindOfClass:[UINavigationController class]])
        [(UINavigationController *)[array objectAtIndex:tabBarController.selectedIndex] popToRootViewControllerAnimated: NO];
}

-(void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if([PFUser currentUser]){
        if ([[tabBar items] indexOfObject:item] == 2)
        {
            [self useCamera];
        
        }
    }
   
    
}



- (void) useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = YES;

        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = YES;
    }
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];

    if ([mediaType isEqualToString:(NSString *) kUTTypeImage]) {
        //#TODO: change
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        
        WVCameraViewController *cameraView = (WVCameraViewController *) self.selectedViewController;
        [cameraView setImageForPreview:image];
        
        
            //[self shouldUploadImage:image];
        
        //saves image to phone
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}



-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
      if (error) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Save failed"
                                  message: @"Failed to save image"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
