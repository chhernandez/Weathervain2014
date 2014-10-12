//
//  WXWeatherViewController.h
//  WeatherVain
//
//  Created by Tehreem Syed on 3/3/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXWeatherViewController : UIViewController <UITableViewDataSource , UITableViewDelegate>
@property (nonatomic, strong) NSString *label;

@property (nonatomic, strong) UIImage *bg_image;
@end
