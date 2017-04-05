//
//  DataSingleTone.h
//  Weather
//
//  Created by jakouk on 2017. 3. 4..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSingleTon : NSObject

+ (instancetype)sharedDataSingleTon;

// Weather Forecast Data
@property NSDictionary *forecastData;
@property NSDictionary *currentData;
@property NSDictionary *weekForcastData;

// DustData
@property NSDictionary *TMData;
@property NSDictionary *mesureStation;
@property NSDictionary *dustData;

@end
