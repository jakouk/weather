//
//  WeatherRequest.h
//  Weather
//
//  Created by jakouk on 2017. 3. 4..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DataSingleTon.h"

typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeForecast,
    RequestTypeCurrent,
    RequestTypeWeekForecast,
    RequestTypeDust,
    RequestTypeTM
};

static NSString *baseURL = @"http://apis.skplanetx.com/weather";

static NSString *dustBaseURL = @"http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty";

static NSString *WGS84ToTMURL = @"https://apis.daum.net/local/geo/transcoord?&fromCoord=WGS84&toCoord=TM&output=json";

@interface WeatherRequest : NSObject

typedef void(^UpdateDataBlock)(void);

/***
 
 requestURL String을 입력받아서 API에 알맞는 String을 반환해 주는 메서드
 
 @author jakoriaty
 @version 1.00
 @param type RequestType의 Enum값을 입력해.
 
 ***/
+ (NSString *)requestURL:(RequestType)type;


/***
 
 AFHTTPSessionManager에 Appkey를 추가해주는 메서드
 
 @author jakoriaty
 @version 1.00
 @param httpSessionManager AFHTTPSSessionManager 객체를 받음.
 
 ***/
+ (void)addAppkey:(AFHTTPSessionManager *)httpSessionManager;


/***
 
 URLString에 ApiKey를 추가해 주는 메서드
 
 @author jakoriaty
 @version 1.00
 @param wgs84URL ApiKey를 추가할 URL
 
 ***/
+ (NSString *)addApiKey:(NSString *)wgs84URL;
@end
