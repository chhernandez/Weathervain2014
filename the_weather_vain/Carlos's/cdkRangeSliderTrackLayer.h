//
//  cdkRangeSliderTrackLayer.h
//  WeatherVain
//
//  Created by Carlos Hernandez on 3/26/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class cdkRangeSlider;

@interface cdkRangeSliderTrackLayer : CALayer

@property (weak) cdkRangeSlider* slider;

@end
