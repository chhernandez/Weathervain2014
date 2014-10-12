//
//  CERangeSlider.h
//  WeatherVain
//
//  Created by itsadmin on 3/29/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CERangeSlider : UIControl


@property (nonatomic) float maximumValue;
@property (nonatomic) float minimumValue;
@property (nonatomic) float upperValue;
@property (nonatomic) float lowerValue;

@property (nonatomic) UIColor* trackColor;
@property (nonatomic) UIColor* trackHighlightColor;
@property (nonatomic) UIColor* knobColor;
@property (nonatomic) float curvaceousness;

-(float) positionForValue:(float)value;

@end
