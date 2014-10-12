//
//  CERangeSlider.m
//  WeatherVain
//
//  Created by itsadmin on 3/29/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import "CERangeSlider.h"
#import <QuartzCore/QuartzCore.h>
#import "CERangeSliderKnobLayer.h"
#import "CERangeSliderTrackLayer.h"

@implementation CERangeSlider
{
    CERangeSliderTrackLayer* _trackLayer;
    CERangeSliderKnobLayer* _upperKnobLayer;
    CERangeSliderKnobLayer* _lowerKnobLayer;
    
    float _knobWidth;
    float _useableTrackLength;
    
    CGPoint _previousTouchPoint;
}

#define GENERATE_SETTER(PROPERTY, TYPE, SETTER, UPDATER) \
- (void)SETTER:(TYPE)PROPERTY { \
if (_##PROPERTY != PROPERTY) { \
_##PROPERTY = PROPERTY; \
[self UPDATER]; \
} \
}
GENERATE_SETTER(trackHighlightColor, UIColor*, setTrackHighlightColor, redrawLayers)

GENERATE_SETTER(trackColor, UIColor*, setTrackColor, redrawLayers)

GENERATE_SETTER(curvaceousness, float, setCurvaceousness, redrawLayers)

GENERATE_SETTER(knobColor, UIColor*, setKnobColor, redrawLayers)

GENERATE_SETTER(maximumValue, float, setMaximumValue, setLayerFrames)

GENERATE_SETTER(minimumValue, float, setMinimumValue, setLayerFrames)

GENERATE_SETTER(lowerValue, float, setLowerValue, setLayerFrames)

GENERATE_SETTER(upperValue, float, setUpperValue, setLayerFrames)

- (void) redrawLayers
{
    [_upperKnobLayer setNeedsDisplay];
    [_lowerKnobLayer setNeedsDisplay];
    [_trackLayer setNeedsDisplay];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        _trackHighlightColor = [UIColor colorWithRed:0.0 green:0.45 blue:0.94 alpha:1.0];
        _trackColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _knobColor = [UIColor whiteColor];
        _curvaceousness = 1.0;
        _maximumValue = 100.0;
        _minimumValue = 0.0;
        _upperValue = 80.0;
        _lowerValue = 20.0;
        
        
        
        _trackLayer = [CERangeSliderTrackLayer layer];
        _trackLayer.slider = self;
        //  _trackLayer.backgroundColor = [UIColor blueColor].CGColor;
        [self.layer addSublayer:_trackLayer];
        
        _upperKnobLayer = [CERangeSliderKnobLayer layer];
        _upperKnobLayer.slider = self;
        //   _upperKnobLayer.backgroundColor = [UIColor greenColor].CGColor;
        [self.layer addSublayer:_upperKnobLayer];
        
        _lowerKnobLayer = [CERangeSliderKnobLayer layer];
        _lowerKnobLayer.slider = self;
        //   _lowerKnobLayer.backgroundColor = [UIColor greenColor].CGColor;
        [self.layer addSublayer:_lowerKnobLayer];
        
        [self setLayerFrames];
        
    }
    return self;
}

- (void) setLayerFrames
{
    _trackLayer.frame = CGRectInset(self.bounds, self.bounds.size.width / 3.5, 0);
    [_trackLayer setNeedsDisplay];
    
    _knobWidth = self.bounds.size.width;
    _useableTrackLength = self.bounds.size.height - _knobWidth;
    
    float upperKnobCentre = [self positionForValue:_upperValue];
    float lowerKnobCentre = [self positionForValue:_lowerValue];
    
    _upperKnobLayer.frame = CGRectMake(0, upperKnobCentre - _knobWidth / 2, _knobWidth, _knobWidth);
    _lowerKnobLayer.frame = CGRectMake(0, lowerKnobCentre - _knobWidth / 2, _knobWidth, _knobWidth);
    
    [_upperKnobLayer setNeedsDisplay];
    [_lowerKnobLayer setNeedsDisplay];
}

- (float) positionForValue:(float)value
{
   // return _useableTrackLength * (value - _minimumValue) / (_maximumValue - _minimumValue) + (_knobWidth / 2);  reverse the value to change the scale to vertical. chh 03/19/14
    return _useableTrackLength * (value - _maximumValue) / (_minimumValue - _maximumValue) + (_knobWidth / 2);
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _previousTouchPoint = [touch locationInView:self];
    
    // hit test the knob layers
    if(CGRectContainsPoint(_lowerKnobLayer.frame, _previousTouchPoint))
    {
        _lowerKnobLayer.highlighted = YES;
        [_lowerKnobLayer setNeedsDisplay];
    }
    else if(CGRectContainsPoint(_upperKnobLayer.frame, _previousTouchPoint))
    {
        _upperKnobLayer.highlighted = YES;
        [_upperKnobLayer setNeedsDisplay];
    }
    return _upperKnobLayer.highlighted || _lowerKnobLayer.highlighted;
}

#define BOUND(VALUE, UPPER, LOWER)	MIN(MAX(VALUE, LOWER), UPPER)

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    // 1. determine by how much the user has dragged
    float delta = touchPoint.y - _previousTouchPoint.y;
  //  float valueDelta = (_maximumValue - _minimumValue) * delta / _useableTrackLength;
    float valueDelta = (_maximumValue - _minimumValue) * delta / _useableTrackLength;
    
    _previousTouchPoint = touchPoint;
    
    // 2. update the values
    if (_lowerKnobLayer.highlighted)
    {
        _lowerValue -= valueDelta;
        _lowerValue = BOUND(_lowerValue, _upperValue, _minimumValue);
        
      //   NSLog(@"hightlighted lowerknobvalue =: %f", _lowerValue);
    }
    if (_upperKnobLayer.highlighted)
    {
        _upperValue -= valueDelta;
        _upperValue = BOUND(_upperValue, _maximumValue, _lowerValue);
       //  NSLog(@"hightlighted upperknobvalue =: %f", _upperValue);
    }
    
    // 3. Update the UI state
    [CATransaction begin];
    [CATransaction setDisableActions:YES] ;
    
    [self setLayerFrames];
    
    [CATransaction commit];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _lowerKnobLayer.highlighted = _upperKnobLayer.highlighted = NO;
    [_lowerKnobLayer setNeedsDisplay];
    [_upperKnobLayer setNeedsDisplay];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
