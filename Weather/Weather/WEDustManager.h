//
//  WEDustManager.h
//  Weather
//
//  Created by jakouk on 2017. 3. 31..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WeatherRequest.h"

@interface WEDustManager : WeatherRequest

+ (void)requestDustData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock;

@end