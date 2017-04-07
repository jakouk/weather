//
//  DWDustManager.h
//  Weather
//
//  Created by jakouk on 2017. 4. 7..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "DWRequest.h"

@interface DWDustManager : DWRequest


/***
 
 WGS84인 latitude와 longitude를 TM Coordinate로 변환하기 위한 메서드
 @author jakoriaty
 @version 1.00
 @param param latitude와 longitude를 입력, 데이터 형식 { y:latitude, x:longitude }
 @param UpdateDataBlock 데이터를 받은후 업데이트 하기 위한 블록
 
 ***/


+ (void)requestWGS84ToTM:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock;


/***
 
 4시간 후 부터의 예보를 3시간 간격으로 72시간까지의 데이터를 받는 메서드
 @author jakoriaty
 @version 1.00
 @param param 위치데이터나 도시의 정보를 Dictionary 타입으로 입력
 @param UpdateDataBlock 데이터를 받은후 업데이트 하기 위한 블록
 
 ***/


+ (void)requestMeasureStationData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock;


/***
 
 4시간 후 부터의 예보를 3시간 간격으로 72시간까지의 데이터를 받는 메서드
 @author jakoriaty
 @version 1.00
 @param param 위치데이터나 도시의 정보를 Dictionary 타입으로 입력
 @param UpdateDataBlock 데이터를 받은후 업데이트 하기 위한 블록
 
 ***/


+ (void)requestDustData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock;

@end
