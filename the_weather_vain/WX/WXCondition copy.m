//
//  WXConditon.m
//  Pods
//
//  Created by Tehreem Syed on 2/8/14.
//
//

#import "WXCondition.h"
#define MPS_TO_MPH 2.23694f
@implementation WXCondition

+ (NSDictionary *) imageMap{
//1
    //same data mapper
    static NSDictionary *_imageMap = nil;
    if(!_imageMap)
    {
    //2
        //mapping condition codes to an image file
        _imageMap = @{
                      @"01d" : @"weather-clear",
                      @"02d" : @"weather-few",
                      @"03d" : @"weather-few",
                      @"04d" : @"weather-broken",
                      @"09d" : @"weather-shower",
                      @"10d" : @"weather-rain",
                      @"11d" : @"weather-tstorm",
                      @"13d" : @"weather-snow",
                      @"50d" : @"weather-mist",
                      @"01n" : @"weather-moon",
                      @"02n" : @"weather-few-night",
                      @"03n" : @"weather-few-night",
                      @"04n" : @"weather-broken",
                      @"09n" : @"weather-shower",
                      @"10n" : @"weather-rain-night",
                      @"11n" : @"weather-tstorm",
                      @"13n" : @"weather-snow",
                      @"50n" : @"weather-mist",
                      };
    }
    return _imageMap;
}
//3
//declare a public message to get an image file name
- (NSString *)imageName {
    return [WXCondition imageMap][self.icon];
}

+(RKObjectMapping *) objectMapping {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    
    [mapping addAttributeMappingsFromDictionary:@{@"dt": @"date",
                                                 @"main.humidity": @"humidity",
                                                 @"main.temp": @"temperature",
                                                 @"main.temp_max": @"tempHigh",
                                                 @"main.temp_min": @"tempLow",
                                                 @"conditionDescription": @"weather.description",
                                                 @"weather.main": @"condition",
                                                 @"weather.icon": @"icon",
                                                 @"wind.deg": @"windBearing",
                                                 @"windSpeed": @"wind.speed"}] ;
    
    return mapping;
}

+ (NSValueTransformer *)dateJSONTransformer {
    // 1
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
    } reverseBlock:^(NSDate *date) {
        return [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    }];
}

//// 2
//+ (NSValueTransformer *)sunriseJSONTransformer {
//    return [self dateJSONTransformer];
//}
//
//+ (NSValueTransformer *)sunsetJSONTransformer {
//    return [self dateJSONTransformer];
//}
//
//+ (NSValueTransformer *)conditionDescriptionJSONTransformer {
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSArray *values) {
//        return [values firstObject];
//    } reverseBlock:^(NSString *str) {
//        return @[str];
//    }];
//}
//
//+ (NSValueTransformer *)conditionJSONTransformer {
//    return [self conditionDescriptionJSONTransformer];
//}
//
//+ (NSValueTransformer *)iconJSONTransformer {
//    return [self conditionDescriptionJSONTransformer];
//}

@end
