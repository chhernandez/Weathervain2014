//
//  WXControllerViewController.h
//  WeatherVain
//
//  Created by Tehreem Syed on 2/8/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
//#import "cdkClosetViewController.h"
#include <unistd.h>

@interface WXController : UIViewController
<UIScrollViewDelegate>

- (void)printWeatherToHomeScreen;
- (void)outfitSuggestionAlgorithm;

@property (weak, nonatomic) IBOutlet UIImageView *Tops;
@property (weak, nonatomic) IBOutlet UIImageView *Bottoms;
@property (weak, nonatomic) IBOutlet UIImageView *Accessories;
@property (weak, nonatomic) IBOutlet UIImageView *Shoes;
@property (weak, nonatomic) IBOutlet UIImageView *myWeatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *myWeatherTemp;
@property (weak, nonatomic) IBOutlet UILabel *myWeatherDescription;
@property (weak, nonatomic) IBOutlet UIImageView *myWeatherTag1;
@property (weak, nonatomic) IBOutlet UIImageView *myWeatherTag2;

@property (strong, nonatomic) NSArray *frigidArray;
@property (strong, nonatomic) NSArray *coldArray;
@property (strong, nonatomic) NSArray *briskArray;
@property (strong, nonatomic) NSArray *mildArray;
@property (strong, nonatomic) NSArray *warmArray;
@property (strong, nonatomic) NSArray *sizzlingArray;
@property (strong, nonatomic) NSArray *hotArray;

@end
