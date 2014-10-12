//
//  WXDailyForecast.m
//  Pods
//
//  Created by Tehreem Syed on 2/8/14.
//
//

#import "WXDailyForecast.h"

@implementation WXDailyForecast


@synthesize clouds, day, deg, desc, dt, eve, humidity, icon, main, max, min, morn, night, pressure, rain, speed;

+ (RKObjectMapping *) objectMapping {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromDictionary:@{@"clouds": @"clouds",
                                                  @"day":@"day",
                                                  @"deg":@"deg",
                                                  @"desc":@"desc",
                                                  @"dt":@"dt",
                                                  @"eve":@"eve",
                                                  @"humidity":@"humidity",
                                                  @"weather.icon":@"icon",
                                                  @"main":@"main",
                                                  @"max":@"max",
                                                  @"min":@"min",
                                                  @"morn":@"morn",
                                                  @"night":@"night",
                                                  @"pressure":@"pressure",
                                                  @"rain":@"rain",
                                                  @"speed":@"speed"}];
    return mapping;
}


//+ (NSDictionary *)JSONKeyPathsByPropertyKey {
//    // 1
//    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
//    // 2
//    paths[@"tempHigh"] = @"temp.max";
//    paths[@"tempLow"] = @"temp.min";
//    // 3
//    return paths;
//}
@end
