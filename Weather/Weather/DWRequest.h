//
//  DWRequest.h
//  Weather
//
//  Created by jakouk on 2017. 4. 7..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DataSingleTon.h"

typedef NS_ENUM(NSInteger, DWRequestType) {
    DWRequestTypeForecast = 1,
    DWRequestTypeCurrent,
    DWRequestTypeWeekForecast,
    DWRequestTypeDust,
    DWRequestTypeTM,
    DWRequestTypeMeasure
};

static NSString *baseURL = @"http://apis.skplanetx.com/weather";

static NSString *WGS84ToTMURL = @"https://apis.daum.net/local/geo/transcoord?&fromCoord=WGS84&toCoord=TM&output=json";

static NSString *dustBaseURL = @"http://openapi.airkorea.or.kr/openapi/services/rest/";



@interface DWRequest : NSObject

typedef void(^UpdateDataBlock)(void);

/***
 
 requestURL String을 입력받아서 API에 알맞는 String을 반환해 주는 메서드
 
 @author jakoriaty
 @version 1.00
 @param type RequestType의 Enum값을 입력해.
 
 ***/
+ (NSString *)requestURL:(DWRequestType)type;


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


/***
 
 URLString에 ServiceKey를 추가해 주는 메서드
 
 @author jakoriaty
 @version 1.00
 @param measuringStationURL ApiKey를 추가할 URL
 
 ***/
+ (NSString *)addServiceKey:(NSString *)measuringStationURL;

/***
 
 URLString에 Parameter를 추가해서 NSURL을 리턴해주는 메서드
 
 @author jakoriaty
 @version 1.00
 @param URLString NSURL로 변환할 URLString
 @param param NSURL로 변환하기전 URLString에 추가할 파라미터
 
 ***/
+ (NSURL *)URLStringToURL:(NSString *)URLString parameter:(NSDictionary *)param;

@end
