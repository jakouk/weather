//
//  WeatherRequest.m
//  Weather
//
//  Created by jakouk on 2017. 3. 4..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WeatherRequest.h"


@implementation WeatherRequest

// reqeustMehotd
+ (NSMutableURLRequest *)requestURL:(NSURL *)url httpMethod:(NSString *)httpMethod{
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    if (![httpMethod isEqualToString:@"POST"]) {
        [urlRequest setHTTPMethod:httpMethod];
    }
    
    return urlRequest;
}

// make URL
+ (NSString *)requestURL:(RequestType)type {
    
    NSMutableString *URLString = [baseURL mutableCopy];
    
    switch (type) {
        case RequestTypeForecast:
            [URLString appendFormat:@"/forecast/3days?version=1"];
    }
    
    return URLString;
    
}


// POSTtype make method
//+ (NSURL *)requestURL:(RequestType)type param:(NSDictionary *)paramDic postData:(NSString *)PostData {
//    
//    NSMutableString *urlString = [baseURL mutableCopy];
//    
//    
//}


+ (void)addAppkey:(AFHTTPSessionManager *)httpSessionManager {
    
    [httpSessionManager.requestSerializer setValue:@"02590c0c-97a5-3b0e-9f7c-34a2f1a0715a" forHTTPHeaderField:@"appkey"];
}

@end
