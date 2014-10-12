//
//  RKClient.h
//  WeatherVain
//
//  Created by Tehreem Syed on 3/6/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RKClient : NSObject

+ (RKClient *) sharedInstance;

@property (nonatomic, strong) RKObjectManager *manager;
@property (nonatomic , strong) AFHTTPClient *httpClient;


- (void) getHourlyForecastWithParameters:(NSDictionary *) parameters
                            withSuccess:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success
                                failure:(void (^)(RKObjectRequestOperation *, NSError *))failure;

- (void) getDailyForecastWithParameters:(NSDictionary *) parameters
                            withSuccess:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success
                                failure:(void (^)(RKObjectRequestOperation *, NSError *))failure;
//

@end
