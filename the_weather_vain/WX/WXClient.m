//
//  WXClient.m
//  Pods
//
//  Created by Tehreem Syed on 2/8/14.
//
//

#import "WXClient.h"
#import "WXCondition.h"
#import "WXDailyForecast.h"

@interface WXClient ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation WXClient


- (id)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
        
        
    }
    return self;
}

- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    NSLog(@"Fetching: %@",url.absoluteString);
    
    // 1
    /*Returns the signal. Remember that this will not execute until this signal is subscribed to. -fetchJSONFromURL: creates an object for other methods and objects to use; this behavior is sometimes called the factory pattern.*/
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        // 2
        /*Creates an NSURLSessionDataTask (also new to iOS 7) to fetch data from the URL. You’ll add the data parsing later*/
        
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            // TODO: Handle retrieved data
            if (! error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (! jsonError) {
                    // 1
                    /*When JSON data exists and there are no errors, send the subscriber the JSON serialized as either an array or dictionary.*/
                    [subscriber sendNext:json];
                }
                else {
                    // 2
                    /*If there is an error in either case, notify the subscriber.*/
                    
                    [subscriber sendError:jsonError];
                }
            }
            else {
                // 2
                [subscriber sendError:error];
            }
            
            //3
            /*Whether the request passed or failed, let the subscriber know that the request has completed.*/
            [subscriber sendCompleted];        }];
        
        // 3
        /*Starts the the network request once someone subscribes to the signal.*/
        [dataTask resume];
        
        // 4
       /* Creates and returns an RACDisposable object which handles any cleanup when the signal when it is destroyed.*/
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        // 5
        /*Adds a “side effect” to log any errors that occur. Side effects don’t subscribe to the signal; rather, they return the signal to which they’re attached for method chaining. You’re simply adding a side effect that logs on error.*/
        NSLog(@"%@",error);
    }];
}

- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate {
    // 1
    /*Format the URL from a CLLocationCoordinate2D object using its latitude and longitude.
*/
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial&APPID=9742f7e9daccd05446b688480c6b0c7a",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 2
    /*Use the method you just built t`o create the signal. Since the returned value is a signal, you can call other ReactiveCocoa methods on it. Here you map the returned value — an instance of NSDictionary — into a different value.*/
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        // 3
       /* Use MTLJSONAdapter to convert the JSON into an WXCondition object, using the MTLJSONSerializing protocol you created for WXCondition.*/
        NSError *error;
        WXCondition *condition = [MTLJSONAdapter modelOfClass:[WXCondition class] fromJSONDictionary:json error:&error];
        return condition;
        
        
    }];
    
    
}
- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=imperial&cnt=7&APPID=9742f7e9daccd05446b688480c6b0c7a",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Use the generic fetch method and map results to convert into an array of Mantle objects
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        // Build a sequence from the list of raw JSON
        RACSequence *list = [json[@"list"] rac_sequence];
        
        // Use a function to map results from JSON to Mantle objects
        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[WXDailyForecast class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=imperial&cnt=12",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 1
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        // 2
        RACSequence *list = [json[@"list"] rac_sequence];
        
        // 3
        return [[list map:^(NSDictionary *item) {
            // 4
            return [MTLJSONAdapter modelOfClass:[WXCondition class] fromJSONDictionary:item error:nil];
            // 5
        }] array];
    }];
}

@end


