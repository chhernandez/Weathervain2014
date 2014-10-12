//
//  cdkRangeSliderKnobLayer.h
//  WeatherVain
//
//  Created by itsadmin on 3/26/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class cdkRangeSlider;

@interface cdkRangeSliderKnobLayer : CALayer

@property BOOL highlighted;
@property (weak) cdkRangeSlider* slider;

@end
