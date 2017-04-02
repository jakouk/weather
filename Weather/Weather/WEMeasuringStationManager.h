//
//  WEMeasuringStationManager.h
//  Weather
//
//  Created by jakouk on 2017. 3. 31..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WeatherRequest.h"

@interface WEMeasuringStationManager : WeatherRequest

+ (void)requestMeasureStationData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock;

@end
