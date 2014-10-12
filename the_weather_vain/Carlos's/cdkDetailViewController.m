//
//  cdkDetailViewController.m
//  FashionExample
//
//  Created by Carlos Hernandez on 2/16/14.
//  Copyright (c) 2014 Carlos Hernandez. All rights reserved.
//

#import "cdkDetailViewController.h"
#import <Parse/Parse.h>
#import "cdkRangeSlider.h"
#import "CERangeSlider.h"
#import "cdkMasterViewController.h"
#import "cdkClosetViewController.h"
#import "SettingsViewController.h"
#import "WVTabBarViewController.h"


@interface cdkDetailViewController ()

- (void)configureView;
@end

@implementation cdkDetailViewController{
    
    cdkRangeSlider* _rangeSlider;
    CERangeSlider* _vrangeSlider;
    
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem objectForKey:@"Label"];
        
      
    //
    //    PFImageView *imageView = [[PFImageView alloc] init];
    //    imageView.image = [UIImage imageNamed:@"..."]; // placeholder image
    //    imageView.file = (PFFile *)someObject[@"picture"]; // remote image
        
       
        
        //  need to find a nice placeholder image. chh 03052014
        // self.itemImage.image = [UIImage imageNamed:@"placeholder.png"];
        self.itemImage.file = [self.detailItem objectForKey:@"Image"];
        
        [self.itemImage loadInBackground];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    /* ************  This code for some reason is producing a black background on the iphone devices. remove and added a plain light gray background chh 05012014
     
     UIGraphicsBeginImageContext(self.view.frame.size);
     [[UIImage imageNamed:@"blurredBG.png"] drawInRect:self.view.bounds];
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     self.view.backgroundColor = [UIColor colorWithPatternImage:image];
     
     
     *******************   */
    
}


- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(320,443);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    [[UILabel appearance] setFont:[UIFont fontWithName:@"RobotoCondensed-Regular.ttf" size:17.0]];
    // **************  Load all customization data from parse to layout  chh 04062014 ********
    
	// Do any additional setup after loading the view.
   /* if (self.detailItem){
        NSLog(@"my object contains: %@", self.detailItem);
         
        
    } else {
        NSLog(@"I have no objects: %d", 0);
    } */
    
   // NSLog(@"this item has a rating =: %@", [self.detailItem objectForKey:@"Rating"]);
    
    NSNumber *myRating = [self.detailItem objectForKey:@"Rating"];
    

    
    self.rateView.notSelectedImage = [UIImage imageNamed:@"star_empty.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"star_half.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"star_full.png"];
    self.rateView.rating = [myRating floatValue];
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
  //  self.statusLabel.text = [NSString stringWithFormat:@"Rating: %@", myRating];
    
 //   NSUInteger leftmargin = 20;
 //   NSUInteger topmargin = 290;
    
  //remove the horizontal range slider. chh 03/29/2014
  /*  CGRect sliderFrame = CGRectMake(leftmargin, topmargin, self.view.frame.size.width - leftmargin * 2, 30);
    _rangeSlider = [[cdkRangeSlider alloc] initWithFrame:sliderFrame];
   
   */
    //  ********* set the individual on/off switch item chh 04062014 **************
    
    NSNumber *myCold = [self.detailItem objectForKey:@"Cold"];
    NSNumber *myHot = [self.detailItem objectForKey:@"Hot"];
    NSNumber *myMild = [self.detailItem objectForKey:@"Mild"];
    NSNumber *myStatus = [self.detailItem objectForKey:@"Status"];
    
    NSNumber *myWarm = [self.detailItem objectForKey:@"Warm"];
    NSNumber *mySizzling = [self.detailItem objectForKey:@"Sizzling"];
    NSNumber *myFrigid = [self.detailItem objectForKey:@"Frigid"];
    NSNumber *myBrisk = [self.detailItem objectForKey:@"Brisk"];
    
  //  NSLog(@"my cloudy value: %@", mySizzling);
    
   // [self.switchSizzling setOn:NO];
    
    if ([mySizzling isEqual:@(0)]){ [self.switchSizzling setOn:NO];}
    else{ [self.switchSizzling setOn:YES]; }
    
    if ([myCold isEqual:@(0)]){ [self.switchCold setOn:NO];}
    else{ [self.switchCold setOn:YES]; }
    
    if ([myHot isEqual:@(0)]){ [self.switchHot setOn:NO];}
    else{ [self.switchHot setOn:YES]; }
    
    if ([myMild isEqual:@(0)]){ [self.switchMild setOn:NO];}
    else{ [self.switchMild setOn:YES]; }
    
    if ([myWarm isEqual:@(0)]){ [self.switchWarm setOn:NO];}
    else{ [self.switchWarm setOn:YES]; }
    
    if ([myStatus isEqual:@(0)]){ [self.switchStatus setOn:NO];}
    else{ [self.switchStatus setOn:YES]; }
    
    if ([myFrigid isEqual:@(0)]){ [self.switchFrigid setOn:NO];}
    else{ [self.switchFrigid setOn:YES]; }
    
    if ([myBrisk isEqual:@(0)]){ [self.switchBrisk setOn:NO];}
    else{ [self.switchBrisk setOn:YES]; }
    
  //  NSUInteger margin = 20;
    CGRect vsliderFrame = CGRectMake(self.view.frame.size.width - 75, 70, 30, 195);
    _vrangeSlider = [[CERangeSlider alloc] initWithFrame:vsliderFrame];
 //   _vrangeSlider.backgroundColor = [UIColor redColor];
    
  //  [self.view addSubview:_rangeSlider];
   // [self.view addSubview:_vrangeSlider];
    
    
    NSNumber *myTempMin = [self.detailItem objectForKey:@"TempMin"];
    NSNumber *myTempMax = [self.detailItem objectForKey:@"TempMax"];
    
    NSString *numStrTempMin = [myTempMin stringValue];
    NSString *numStrTempMax = [myTempMax stringValue];
    
    self.tempMinLabel.text = [NSString stringWithFormat:@"%@", numStrTempMin];
    self.tempMaxLabel.text = [NSString stringWithFormat:@"%@", numStrTempMax];
    
    _vrangeSlider.lowerValue = [myTempMin floatValue];
    _vrangeSlider.upperValue = [myTempMax floatValue];
    
   // _rangeSlider.backgroundColor = [UIColor redColor];
    
  //  [self.view addSubview:_vrangeSlider];
    
    [_vrangeSlider addTarget:self
                     action:@selector(slideValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    
	//  This code is to test the macro's above. not needed. chh 03/26/2014
    //[self performSelector:@selector(updateState) withObject:nil afterDelay:1.0f];
    
    [self configureView];
    
    
} // end of viewDidLoad


//  This code is to test the macro's above. not needed. chh 03/26/2014- (void)updateState
/*{
    _rangeSlider.trackHighlightColor = [UIColor redColor];
    _rangeSlider.curvaceousness = 0.0;
} */

- (void)slideValueChanged:(id)control
{
   // NSLog(@"Slider value changed: (%.2f,%.2f)", _rangeSlider.lowerValue, _rangeSlider.upperValue);
    
    NSNumber *minTempValue = [NSNumber numberWithFloat:_vrangeSlider.lowerValue];
    NSNumber *maxTempValue = [NSNumber numberWithFloat:_vrangeSlider.upperValue];
    
    NSString *numStrTempMin = [minTempValue stringValue];
    NSString *numStrTempMax = [maxTempValue stringValue];
    
    self.tempMinLabel.text = [NSString stringWithFormat:@"%@", numStrTempMin];
    self.tempMaxLabel.text = [NSString stringWithFormat:@"%@", numStrTempMax];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Add to bottom
- (void)rateView:(cdkRateView *)rateView ratingDidChange:(float)rating {
  //  self.statusLabel.text = [NSString stringWithFormat:@"Rating: %f", rating];

    
}


// replace the save navigation to a button action below to avoid stacking screens. chh 10052014
/* - (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
  //  if ([segue.identifier isEqualToString:@"saveCustomDetails"]) {
        //  Save all the data in parse here before going to the closet page. chh 03222014
  //      NSLog(@"Saving a new rating =: %f", self.rateView.rating);
      //  NSLog(@"this item has a id =: %@", [self.detailItem objectId]);
        
      //  NSLog(@"Slider value changed: (%.2f,%.2f)", _rangeSlider.lowerValue, _rangeSlider.upperValue);
        
      //  NSLog(@"my cloudy switchvalue: %@", self.switchSizzling);
   if ([segue.identifier isEqualToString:@"saveToCloset"]) {
       
 
 NSLog(@"Saving a new rating =: %f", self.rateView.rating);
 
 int mySizzling = 0;
 int myCold = 0;
 int myHot = 0;
 int myMild = 0;
 int myWarm = 0;
 int myStatus = 0;
 int myFrigid = 0;
 int myBrisk = 0;
 
 if (self.switchSizzling.on) { mySizzling = 1; };
 if (self.switchCold.on) { myCold = 1; };
 if (self.switchHot.on) { myHot = 1; };
 if (self.switchMild.on) { myMild = 1; };
 if (self.switchWarm.on) { myWarm = 1; };
 if (self.switchStatus.on) { myStatus = 1; };
 if (self.switchFrigid.on) { myFrigid = 1; };
 if (self.switchBrisk.on) { myBrisk = 1; };
 
 
 PFQuery *query = [PFQuery queryWithClassName:@"Closet"];
 [query getObjectInBackgroundWithId:[self.detailItem objectId] block:^(PFObject *updateItem, NSError *error) {
 updateItem[@"Rating"] = [NSNumber numberWithFloat:self.rateView.rating];
 
 updateItem[@"Sizzling"] = [NSNumber numberWithInt:mySizzling];
 updateItem[@"Cold"] = [NSNumber numberWithInt:myCold];
 updateItem[@"Hot"] = [NSNumber numberWithInt:myHot];
 updateItem[@"Mild"] = [NSNumber numberWithInt:myMild];
 updateItem[@"Warm"] = [NSNumber numberWithInt:myWarm];
 updateItem[@"Status"] = [NSNumber numberWithInt:myStatus];
 updateItem[@"Frigid"] = [NSNumber numberWithInt:myFrigid];
 updateItem[@"Brisk"] = [NSNumber numberWithInt:myBrisk];
 
 //       updateItem[@"TempMin"] = [NSNumber numberWithFloat:_vrangeSlider.lowerValue];
 //      updateItem[@"TempMax"] = [NSNumber numberWithFloat:_vrangeSlider.upperValue];
 [updateItem saveInBackground];
 }];
 
    } else {
        return;
    }
 
} */

/*//  no longer using the save button. chh 04212014

- (IBAction)actionSave:(id)sender {
 
    NSLog(@"Saving a new rating =: %f", self.rateView.rating);
 
    int mySizzling = 0;
    int myCold = 0;
    int myHot = 0;
    int myMild = 0;
    int myWarm = 0;
    int myStatus = 0;
    int myFrigid = 0;
    int myBrisk = 0;
    
    if (self.switchSizzling.on) { mySizzling = 1; };
    if (self.switchCold.on) { myCold = 1; };
    if (self.switchHot.on) { myHot = 1; };
    if (self.switchMild.on) { myMild = 1; };
    if (self.switchWarm.on) { myWarm = 1; };
    if (self.switchStatus.on) { myStatus = 1; };
    if (self.switchFrigid.on) { myFrigid = 1; };
    if (self.switchBrisk.on) { myBrisk = 1; };
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Closet"];
    [query getObjectInBackgroundWithId:[self.detailItem objectId] block:^(PFObject *updateItem, NSError *error) {
        updateItem[@"Rating"] = [NSNumber numberWithFloat:self.rateView.rating];
        
        updateItem[@"Sizzling"] = [NSNumber numberWithInt:mySizzling];
        updateItem[@"Cold"] = [NSNumber numberWithInt:myCold];
        updateItem[@"Hot"] = [NSNumber numberWithInt:myHot];
        updateItem[@"Mild"] = [NSNumber numberWithInt:myMild];
        updateItem[@"Warm"] = [NSNumber numberWithInt:myWarm];
        updateItem[@"Status"] = [NSNumber numberWithInt:myStatus];
        updateItem[@"Frigid"] = [NSNumber numberWithInt:myFrigid];
        updateItem[@"Brisk"] = [NSNumber numberWithInt:myBrisk];
        
        //       updateItem[@"TempMin"] = [NSNumber numberWithFloat:_vrangeSlider.lowerValue];
        //      updateItem[@"TempMax"] = [NSNumber numberWithFloat:_vrangeSlider.upperValue];
        [updateItem saveInBackground];
    }];

    
   [self dismissViewControllerAnimated:YES completion:nil];
    
   // note: when user click save button, it saves, but it doesn't refresh the table view master data until they pull to refresh.  Tried a few ideas but without success. chh 04182014
    
    //take the user to login screen if not logged in. chh 04102014
  //  cdkMasterViewController *viewController = [[cdkMasterViewController alloc] init];
  //  [self presentViewController:viewController animated:YES completion:nil];
    
 
    
    //[cdkMasterViewController load];
    
   
}
*/

/*- (IBAction)mySaveItemButton:(id)sender {
    

    
}*/


- (IBAction)mySaveButton:(id)sender {
    
    // go back to action button but within navigation to let user go straight back to main menu without stacking screens. chh 10052014
    
    NSLog(@"Saving a new rating =: %f", self.rateView.rating);
    
    int mySizzling = 0;
    int myCold = 0;
    int myHot = 0;
    int myMild = 0;
    int myWarm = 0;
    int myStatus = 0;
    int myFrigid = 0;
    int myBrisk = 0;
    
    if (self.switchSizzling.on) { mySizzling = 1; };
    if (self.switchCold.on) { myCold = 1; };
    if (self.switchHot.on) { myHot = 1; };
    if (self.switchMild.on) { myMild = 1; };
    if (self.switchWarm.on) { myWarm = 1; };
    if (self.switchStatus.on) { myStatus = 1; };
    if (self.switchFrigid.on) { myFrigid = 1; };
    if (self.switchBrisk.on) { myBrisk = 1; };
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Closet"];
    [query getObjectInBackgroundWithId:[self.detailItem objectId] block:^(PFObject *updateItem, NSError *error) {
        updateItem[@"Rating"] = [NSNumber numberWithFloat:self.rateView.rating];
        
        updateItem[@"Sizzling"] = [NSNumber numberWithInt:mySizzling];
        updateItem[@"Cold"] = [NSNumber numberWithInt:myCold];
        updateItem[@"Hot"] = [NSNumber numberWithInt:myHot];
        updateItem[@"Mild"] = [NSNumber numberWithInt:myMild];
        updateItem[@"Warm"] = [NSNumber numberWithInt:myWarm];
        updateItem[@"Status"] = [NSNumber numberWithInt:myStatus];
        updateItem[@"Frigid"] = [NSNumber numberWithInt:myFrigid];
        updateItem[@"Brisk"] = [NSNumber numberWithInt:myBrisk];
        
        //       updateItem[@"TempMin"] = [NSNumber numberWithFloat:_vrangeSlider.lowerValue];
        //      updateItem[@"TempMax"] = [NSNumber numberWithFloat:_vrangeSlider.upperValue];
        [updateItem saveInBackground];
    }];
    //take the user to login screen if not logged in. chh 04102014
    
      //take the user to login screen if not logged in. chh 04102014
//    [self.navigationController popViewController];
//
 //   SettingsViewController *viewController = [[SettingsViewController alloc] init];
 //   [self presentViewController:viewController animated:YES completion:nil];
    
}
@end
