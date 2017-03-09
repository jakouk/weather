//
//  WEForecastManager.h
//  Weather
//
//  Created by jakouk on 2017. 3. 4..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WeatherRequest.h"

@interface WEForecastManager : WeatherRequest


/***
 
 4시간 후 부터의 예보를 3시간 간격으로 72시간까지의 데이터를 받는 메서드
 @author jakoriaty
 @version 1.00
 @param param 위치데이터나 도시의 정보를 Dictionary 타입으로 입력
 @param UpdateDataBlock 데이터를 받은후 업데이터 하기 위한 블록
 
 ***/

+ (void)requestForecastData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock;

@end
