//
//  WeatherRequest.h
//  Weather
//
//  Created by jakouk on 2017. 3. 4..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeForecast
};

static NSString *baseURL = @"http://apis.skplanetx.com/weather";

@interface WeatherRequest : NSObject

typedef void(^UpdateDataBlock)(void);

// GetType make URL
+ (NSURL *)requestURL:(RequestType)type param:(NSDictionary *)paramDic;

// POSTtype make URL
+ (NSURL *)requestURL:(RequestType)type param:(NSDictionary *)paramDic postData:(NSString *)PostData;

// reqeustMehotd
+ (NSMutableURLRequest *)requestURL:(NSURL *)url httpMethod:(NSString *)httpMethod;

// addAppkey
+ (void)addAppkey:(AFHTTPSessionManager *)httpSessionManager;

@end
