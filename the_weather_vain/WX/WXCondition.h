//
//  WXConditon.h
//  Pods
//
//  Created by Tehreem Syed on 2/8/14.
//
//

#import "Mantle.h"
//1
//The MTLJSONSerializing protocol tells the Mantle serializer that this object has instructions on how to map JSON to Objective-C properties.
@interface WXCondition : MTLModel < MTLJSONSerializing>

//2
//weather data properties
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber * tempHigh;
@property (nonatomic, strong) NSNumber *tempLow;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSDate *sunrise;
@property (nonatomic, strong) NSDate *sunset;
@property (nonatomic, strong) NSString *conditionDescription;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) NSNumber *windBearing;
@property (nonatomic, strong) NSNumber *windSpeed;
@property (nonatomic, strong) NSString *icon;

// 3
//method to map weather conditions to image files
- (NSString *)imageName;


@end
