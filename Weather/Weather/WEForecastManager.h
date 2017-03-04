//
//  WEForecastManager.h
//  Weather
//
//  Created by jakouk on 2017. 3. 4..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WeatherRequest.h"

@interface WEForecastManager : WeatherRequest

// request ForecastData
+ (void)requestForecastData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock;

@end
