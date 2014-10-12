//
//  CERangeSliderKnobLayer.h
//  WeatherVain
//
//  Created by Carlos Hernandez on 3/29/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class CERangeSlider;

@interface CERangeSliderKnobLayer : CALayer

@property BOOL highlighted;
@property (weak) CERangeSlider* slider;

@end
