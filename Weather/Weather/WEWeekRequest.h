//
//  WEWeekRequest.h
//  Weather
//
//  Created by jakouk on 2017. 3. 21..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WeatherRequest.h"

@interface WEWeekRequest : WeatherRequest

/***
 
 2일 ~ 10일간의 예보
 @author jakoriaty
 @version 1.00
 @param param 위치데이터나 도시의 정보를 Dictionary 타입으로 입력
 @param UpdateDataBlock 데이터를 받은후 업데이트 하기 위한 블록
 
 ***/

+ (void)requestWeekForcastData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock;

@end
