//
//  MainPageViewController.h
//  WeatherVain
//
//  Created by Tehreem Syed on 3/3/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) UIImage *bg_image;


@end
