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
        case RequestTypeWeekForecast:
            [URLString appendString:@"/forecast/6days?version=1"];
            break;
        case RequestTypeDust:
            URLString = [dustBaseURL mutableCopy];
            break;
        case RequestTypeTM:
            URLString = [WGS84ToTMURL mutableCopy];
            break;
        case RequestTypeMeasure:
            URLString = [measureStationURL mutableCopy];
            break;
    }
    
    return URLString;
    
}


+ (void)addAppkey:(AFHTTPSessionManager *)httpSessionManager {
    
    [httpSessionManager.requestSerializer setValue:@"02590c0c-97a5-3b0e-9f7c-34a2f1a0715a" forHTTPHeaderField:@"appkey"];
}

+ (NSString *)addApiKey:(NSString *)wgs84URL{
    
    NSString *apiKey = @"&apikey=01ae38cbc4a9cdb7b6731ea3622090fd";
    NSString *wgsToTMString = [[NSString alloc] initWithFormat:@"%@&%@",wgs84URL,apiKey];
    
    return wgsToTMString;
}

+ (NSString *)addServiceKey:(NSString *)measuringStationURL{
    
    NSString *apiKey = @"ServiceKey=9kYhn8M%2Fkhy4kao771LwsfzsIbzxZ%2BYYBLDc9HEfjTUrySr%2F8goletIQ%2B2ziphUAAqVIzX2CATxf6eGLo8sWxw%3D%3D";
    NSString *measuringStatingURLString = [[NSString alloc] initWithFormat:@"%@&%@",measuringStationURL,apiKey];
    
    return measuringStatingURLString;
}

+ (NSURL *)URLStringToURL:(NSString *)URLString parameter:(NSDictionary *)param {
    
    NSMutableString *mutableURLString = [[NSMutableString alloc] initWithString:URLString];
    
    for (NSString *key in param) {
        
        [mutableURLString appendFormat:@"&%@",key];
        [mutableURLString appendFormat:@"=%@",param[key]];
    }
    
    NSURL *URL = [[NSURL alloc] initWithString:mutableURLString];
    
    return URL;
}


@end
