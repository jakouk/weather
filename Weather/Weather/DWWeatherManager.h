//
//  DWWeatherManager.h
//  Weather
//
//  Created by jakouk on 2017. 4. 7..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "DWRequest.h"

@interface DWWeatherManager : DWRequest


/***
 
 4시간 후 부터의 예보를 3시간 간격으로 72시간까지의 데이터를 받는 메서드
 @author jakoriaty
 @version 1.00
 @param param 위치데이터나 도시의 정보를 Dictionary 타입으로 입력 
 @param UpdateDataBlock 데이터를 받은후 업데이터 하기 위한 블록
 
 ***/

+ (void)requestForecastData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock;


/***
 
 현재위치의 날씨나 온도를 받는 메서드
 @author jakoriaty
 @version 1.00
 @param param 위치데이터나 도시의 정보를 Dictionary 타입으로 입력
 @param UpdateDataBlock 데이터를 받은후 업데이터 하기 위한 블록
 
 ***/

+ (void)requestCurrenttData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock;


/***
 
 2일 ~ 10일간의 예보
 @author jakoriaty
 @version 1.00
 @param param 위치데이터나 도시의 정보를 Dictionary 타입으로 입력
 @param UpdateDataBlock 데이터를 받은후 업데이트 하기 위한 블록
 
 ***/

+ (void)requestWeekForcastData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock;




+ (void)requestWeekForecastDataLongitude:(NSString *)longitude village:(NSString *)village country:(NSString *)country foretxt:(NSString *)foretxt latitude:(NSString *)latitude city:(NSString *)city updateDataBlock:(UpdateDataBlock)UpdateDataBlock;





@end
