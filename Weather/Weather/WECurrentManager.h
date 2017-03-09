//
//  WECurrentManager.h
//  Weather
//
//  Created by jakouk on 2017. 3. 7..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WeatherRequest.h"

@interface WECurrentManager : WeatherRequest

/***
 
 현재위치의 날씨나 온도를 받는 메서드
 @author jakoriaty
 @version 1.00
 @param param 위치데이터나 도시의 정보를 Dictionary 타입으로 입력
 @param UpdateDataBlock 데이터를 받은후 업데이터 하기 위한 블록
 
 ***/

+ (void)requestCurrenttData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock;

@end
