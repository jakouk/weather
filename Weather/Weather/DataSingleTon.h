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

// forecastData
@property NSDictionary *forecastData;

@end
