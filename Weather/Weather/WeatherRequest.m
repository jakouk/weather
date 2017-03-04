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

// GetType make method
+ (NSURL *)requestURL:(RequestType)type param:(NSDictionary *)paramDic {
    
    NSMutableString *urlString = [baseURL mutableCopy];
    
    switch (type) {
        case RequestTypeForecast:
            [urlString appendFormat:@"/forecast/3days?"];
            
    }
    
    if ([paramDic count]) {
        NSMutableString *paramString = [NSMutableString stringWithFormat:@"?"];
        
        for (NSString *key in paramDic) {
            [paramString appendString:key];
            [paramString appendString:@"="];
            
            if (paramDic[key] != nil) {
                id value = paramDic[key];
              
                if ([value isKindOfClass:[NSString class]]) {
                    [paramString appendString:value];
                }
                
                [paramString appendString:@"&"];
            }
            
        }
        [urlString appendString:paramString];
    }
    
    return [NSURL URLWithString:urlString];
    
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
