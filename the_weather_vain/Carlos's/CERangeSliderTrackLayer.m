//
//  CERangeSliderTrackLayer.m
//  WeatherVain
//
//  Created by Carlos Hernandez on 3/29/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import "CERangeSliderTrackLayer.h"
#import "CERangeSlider.h"

@implementation CERangeSliderTrackLayer

- (void)drawInContext:(CGContextRef)ctx
{
    // clip
    float cornerRadius = self.bounds.size.height * self.slider.curvaceousness / 2.0;
    UIBezierPath *switchOutline = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                             cornerRadius:cornerRadius];
	CGContextAddPath(ctx, switchOutline.CGPath);
    CGContextClip(ctx);
    
    // 1) fill the track
    CGContextSetFillColorWithColor(ctx, self.slider.trackColor.CGColor);
    CGContextAddPath(ctx, switchOutline.CGPath);
    CGContextFillPath(ctx);
    
    // 2) fill the highlighed range
    CGContextSetFillColorWithColor(ctx, self.slider.trackHighlightColor.CGColor);
    float lower = [self.slider positionForValue:self.slider.lowerValue];
    float upper = [self.slider positionForValue:self.slider.upperValue];
    // switch the x,y and width, hieght for vertical range. chh 03/29/14
    CGContextFillRect(ctx, CGRectMake(0, lower, self.bounds.size.height, upper - lower));
    
    // 3) add a highlight over the track
    // switch the x,y and width, hieght for vertical range. chh 03/29/14
    CGRect highlight = CGRectMake(self.bounds.size.height/2,cornerRadius/2, self.bounds.size.height/2, self.bounds.size.width - cornerRadius);
    UIBezierPath *highlightPath = [UIBezierPath bezierPathWithRoundedRect:highlight
                                                             cornerRadius:highlight.size.height * self.slider.curvaceousness / 2.0];
    CGContextAddPath(ctx, highlightPath.CGPath);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:1.0 alpha:0.4].CGColor);
    CGContextFillPath(ctx);
    
    // 4) inner shadow
    CGContextSetShadowWithColor(ctx, CGSizeMake(2.0, 0), 3.0, [UIColor grayColor].CGColor);
    CGContextAddPath(ctx, switchOutline.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextStrokePath(ctx);
    
    // 5) outline the track
    CGContextAddPath(ctx, switchOutline.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextStrokePath(ctx);
}
@end
