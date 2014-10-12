//
//  RKClient.m
//  WeatherVain
//
//  Created by Tehreem Syed on 3/6/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import "RKClient.h"
#import "WXCondition.h"
#import "WXDailyForecast.h"

@implementation RKClient

@synthesize manager;
@synthesize httpClient;

static RKClient *sharedInstance = nil;

+ (RKClient *) sharedInstance {
    
    @synchronized(self) {
        if(sharedInstance == nil){
            sharedInstance = [[RKClient alloc] init];
        }
        
        return sharedInstance;
    }
}

- (id) init{
    
    self = [super init];
    
    if(self){
        [self setupConnector];
        [self setupMapping];
    }
    
    return self;
}

- (void) setupConnector {
    
    if (!manager) {
        
        httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/"]] ;
        
        manager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];
//        manager.requestSerializationMIMEType = RKM;

    }
}


-(void) setupMapping {
    
//    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[WXDailyForecast objectMapping]
//                                                                                method:RKRequestMethodGET
//                                                                           pathPattern:@"forecast/daily"
//                                                                               keyPath:@"list"
//                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
//    
//    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[WXCondition objectMapping]
//                                                                                method:RKRequestMethodGET
//                                                                           pathPattern:@"forecast"
//                                                                               keyPath:@"list"
//                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
//    
//    
//    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[WXCondition objectMapping]
//                                                                                method:RKRequestMethodGET
//                                                                           pathPattern:@"weather"
//                                                                               keyPath:Nil
//                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
}


- (void) getHourlyForecastWithParameters:(NSDictionary *) parameters
                            withSuccess:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success
                                failure:(void (^)(RKObjectRequestOperation *, NSError *))failure{
    
    [manager getObjectsAtPath:@"forecast" parameters:parameters
                      success:success
                      failure:failure];
    
}

- (void) getDailyForecastWithParameters:(NSDictionary *) parameters
                             withSuccess:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success
                                 failure:(void (^)(RKObjectRequestOperation *, NSError *))failure {
    
    [manager getObjectsAtPath:@"forecast/daily" parameters:parameters
                      success:success
                      failure:failure];
    
}


@end
