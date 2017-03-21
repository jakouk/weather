//
//  WEWeekRequest.h
//  Weather
//
//  Created by jakouk on 2017. 3. 21..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WeatherRequest.h"

@interface WEWeekRequest : WeatherRequest

+ (void)requestWeekForcastData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock;

@end
