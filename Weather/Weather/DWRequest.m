//
//  DWRequest.m
//  Weather
//
//  Created by jakouk on 2017. 4. 7..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "DWRequest.h"

@implementation DWRequest

// make URL
+ (NSString *)requestURL:(DWRequestType)type {
    
    NSMutableString *URLString = [baseURL mutableCopy];
    
    switch (type) {
        case DWRequestTypeForecast:
            [URLString appendFormat:@"/forecast/3days?version=1"];
            break;
        case DWRequestTypeCurrent:
            [URLString appendFormat:@"/current/minutely?version=1"];
            break;
        case DWRequestTypeWeekForecast:
            [URLString appendString:@"/forecast/6days?version=1"];
            break;
        case DWRequestTypeDust:
            URLString = [dustBaseURL mutableCopy];
            [URLString appendString:@"ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?dataTerm=month&pageNo=1&numOfRows=10&ver=1.3&_returnType=json"];
            break;
        case DWRequestTypeTM:
            URLString = [WGS84ToTMURL mutableCopy];
            break;
        case DWRequestTypeMeasure:
            URLString = [dustBaseURL mutableCopy];
            [URLString appendString:@"MsrstnInfoInqireSvc/getNearbyMsrstnList?pageNo=1&numOfRows=10&_returnType=json"];
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

+ (NSDictionary *)SKPlanetAPILogitude:(NSString *)longitude village:(NSString *)village country:(NSString *)country foretxt:(NSString *)foretxt latitude:(NSString *)latitude city:(NSString *)city {
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    
    if ( longitude == nil ) {
        longitude = @"";
    }
    
    if ( village == nil ) {
        village = @"";
    }
    
    if ( country == nil ) {
        country = @"";
    }
    
    if ( foretxt == nil ) {
        foretxt = @"";
    }
    
    if ( latitude == nil ) {
        latitude = @"";
    }
    
    if ( city == nil ) {
        city = @"";
    }
    
    NSDictionary *param = @{@"lon":longitude,@"village":village,@"country":country,@"foretxt":foretxt,@"lat":latitude,@"city":city};
    
    for ( NSString *key in param ) {
        
        if ( param[key] == nil ) {
            
            [parameter setObject:key forKey:@""];
            
        } else {
            
             [parameter setObject:param[key] forKey:key];
            
        }
        
    }
    
    return parameter;
}


@end
