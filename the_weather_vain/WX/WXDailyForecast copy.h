//
//  WXDailyForecast.h
//  Pods
//
//  Created by Tehreem Syed on 2/8/14.
//
//

#import "WXCondition.h"

@interface WXDailyForecast : NSObject

@property (nonatomic, strong) NSNumber *dt;
@property (nonatomic, strong) NSNumber *day;
@property (nonatomic, strong) NSNumber *min;
@property (nonatomic, strong) NSNumber *max;
@property (nonatomic, strong) NSNumber *night;
@property (nonatomic, strong) NSNumber *eve;
@property (nonatomic, strong) NSNumber *morn;
@property (nonatomic, strong) NSNumber *pressure;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *speed;
@property (nonatomic, strong) NSNumber *deg;
@property (nonatomic, strong) NSNumber *clouds;
@property (nonatomic, strong) NSNumber *rain;
@property (nonatomic, strong) NSString *main;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *icon;

+ (RKObjectMapping *) objectMapping;

@end
