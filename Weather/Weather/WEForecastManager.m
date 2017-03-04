//
//  WEForecastManager.m
//  Weather
//
//  Created by jakouk on 2017. 3. 4..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WEForecastManager.h"
#import <AFNetworking.h>
#import "DataSingleTon.h"

@implementation WEForecastManager

+ (void)requestForecastData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = @"http://apis.skplanetx.com/weather/forecast/3days?version=1";
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self addAppkey:manager];
    
    [manager GET:URLString parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"성공");
        NSLog(@"%@",responseObject);
        
        [DataSingleTon sharedDataSingleTon].forecastData = responseObject;
        UpdateDataBlock();
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"실패");
        NSLog(@"%@",error);
        
    }];
    
}

@end
