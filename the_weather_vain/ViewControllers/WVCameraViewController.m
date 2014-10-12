//
//  WVCameraViewController.m
//  WeatherVain
//
//  Created by Tehreem Syed on 4/8/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import "WVCameraViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "WXManager.h"
#import "cdkMainViewController.h"

@interface WVCameraViewController ()
@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, strong) PFFile *thumbnailFile;
@property (nonatomic, strong) NSString *photoWeatherTag;


@end

@implementation WVCameraViewController


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
    [super viewDidLoad];
    
    self.title=@"";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"profile_TopBG"]]];

   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated{
    
   if(![PFUser currentUser] && !self.showedLoginError)
    {
        self.showedLoginError = true;
        
        
    }
  
    
    if ([self.preview image]) {
        //Get current weather tag
        NSString *currentWeatherTag = [WXManager sharedManager].getCurrentWeatherTag;
        self.pictureDetailView.hidden = NO;
        self.currentTag.text = currentWeatherTag;
        self.photoWeatherTag = currentWeatherTag;
        
    } else {
        self.tabBarController.selectedIndex=0;
    }

    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    
    if (![buttonTitle isEqualToString:@"Cancel"]) {
        self.photoWeatherTag = buttonTitle;

        self.currentTag.text = buttonTitle;

    }
    //self.currentTag.text = buttonTitle;
    
    
   
   
}

- (IBAction)action_upload_image:(id)sender {
    [self shouldUploadImage:[self.preview image]];
}

- (BOOL)shouldUploadImage:(UIImage *)anImage {
    
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailImage = [anImage thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    PFObject *photo = [PFObject objectWithClassName:@"Photo"];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);
    
    if (!imageData || !thumbnailImageData) {
        return NO;
    }
    
    self.photoFile = [PFFile fileWithData:imageData];
    self.thumbnailFile = [PFFile fileWithData:thumbnailImageData];
    
    photo[@"image"] = self.photoFile;
    photo[@"thumbnail"] = self.thumbnailFile;
    photo[@"private"]  = [NSNumber numberWithBool:self.switch_private.isOn];
    photo[@"weatherTag"] = self.photoWeatherTag;
    
    //if user is logged
    if ([PFUser currentUser]) {
        photo[@"user"] = [PFUser currentUser];
    }
    
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Success: %i error:%@", succeeded, error);
        [self.preview setImage:nil];
        self.pictureDetailView.hidden = YES;
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:3];
        
    }];
    
    return YES;
}

-(void) setImageForPreview:(UIImage *) image{
    [self.preview setImage:image];
}
- (IBAction)action_show_tag_action:(id)sender {
    //Set tags using UIAction Sheet
    UIActionSheet *sheet;
    sheet = [[UIActionSheet alloc] initWithTitle:@"Weather tag"
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"Frigid",@"Cold", @"Brisk", @"Mild",@"Warm",@"Hot",@"Sizzling",@"Rainy", nil];
    //show the sheet
    [sheet showInView:self.view];

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
