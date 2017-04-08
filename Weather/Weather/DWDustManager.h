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
 @param latitude latitude 경도
 @param longitude longitude 위도
 @param UpdateDataBlock 데이터를 받은후 업데이트 하기 위한 블록
 
 ***/

+ (void)requestWGS84ToTM:(NSString *)latitude longitude:(NSString *)longitude updateDataBlock:(UpdateDataBlock)UpdateDataBlock;

/***
 
 tm좌표를 기준으로 해서 가까운 측정소부터 목록을 불러오는 메서드
 @author jakoriaty
 @version 1.00
 @param tmX tm 좌표의 X
 @param tmY tm 좌표의 Y
 @param UpdateDataBlock 데이터를 받은후 업데이트 하기 위한 블록
 
 ***/


+ (void)requestMeasureStationData:(NSString *)tmX yCoordinate:(NSString *)tmY updateDataBlock:(UpdateDataBlock)UpdateDataBlock;


/***
 
 현재위치에서 가장 가까운 위치의 스테이션에서 미세먼지 데이터를 가져오는 메서드
 @author jakoriaty
 @version 1.00
 @param station 미세먼지 검사 스테이션 이름
 @param UpdateDataBlock 데이터를 받은후 업데이트 하기 위한 블록
 
 ***/


+ (void)requestDustData:(NSString *)station updateDataBlock:(UpdateDataBlock)UpdateDataBlock;



@end
