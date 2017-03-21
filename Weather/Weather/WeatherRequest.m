//
//  WeatherRequest.m
//  Weather
//
//  Created by jakouk on 2017. 3. 4..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WeatherRequest.h"


@implementation WeatherRequest


// make URL
+ (NSString *)requestURL:(RequestType)type {
    
    NSMutableString *URLString = [baseURL mutableCopy];
    
    switch (type) {
        case RequestTypeForecast:
            [URLString appendFormat:@"/forecast/3days?version=1"];
            break;
        case RequestTypeCurrent:
            [URLString appendFormat:@"/current/minutely?version=1"];
            break;
        case RequestTypeWeekForcast:
            [URLString appendString:@"/forecast/6days?version=1"];
            break;
    }
    
    return URLString;
    
}


+ (void)addAppkey:(AFHTTPSessionManager *)httpSessionManager {
    
    [httpSessionManager.requestSerializer setValue:@"02590c0c-97a5-3b0e-9f7c-34a2f1a0715a" forHTTPHeaderField:@"appkey"];
}

@end
