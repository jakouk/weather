//
//  DWWeatherManager.m
//  Weather
//
//  Created by jakouk on 2017. 4. 7..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "DWWeatherManager.h"

@implementation DWWeatherManager


+ (void)requestForecastData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = [self requestURL:DWRequestTypeForecast];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self addAppkey:manager];
    
    [manager GET:URLString parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [DataSingleTon sharedDataSingleTon].forecastData = responseObject;
            UpdateDataBlock();
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"예보 네트워크 연결 실패");
            
            
        }];
    
}


+ (void)requestCurrenttData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = [self requestURL:DWRequestTypeCurrent];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self addAppkey:manager];
    
    [manager GET:URLString parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [DataSingleTon sharedDataSingleTon].currentData = responseObject;
            UpdateDataBlock();
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"현재 온도 네트워크 연결 실패");
            
        }];
    
}


+ (void)requestWeekForcastData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = [self requestURL:DWRequestTypeWeekForecast];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self addAppkey:manager];
    
    [manager GET:URLString parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [DataSingleTon sharedDataSingleTon].weekForcastData = responseObject;
            UpdateDataBlock();
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"6일 예보 실패");
            
        }];
    
    
}


+ (void)requestTwoDayForecastDataLongitude:(NSString *)longitude village:(NSString *)village country:(NSString *)country foretxt:(NSString *)foretxt latitude:(NSString *)latitude city:(NSString *)city updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    
    NSString *URLString = [self requestURL:DWRequestTypeForecast];
    
    NSDictionary *parameter =  [self SKPlanetAPILogitude:longitude village:village country:country foretxt:foretxt latitude:latitude city:city];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self addAppkey:manager];
    
    [manager GET:URLString parameters:parameter
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [DataSingleTon sharedDataSingleTon].forecastData = responseObject;
            NSLog(@"TwoDay responseObject = %@",responseObject);
            UpdateDataBlock();
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"현재 온도 네트워크 연결 실패");
            
        }];
    
    
}


#pragma mark currentData
+ (void)requestCurrentDataLongitude:(NSString *)longitude village:(NSString *)village country:(NSString *)country foretxt:(NSString *)foretxt latitude:(NSString *)latitude city:(NSString *)city updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = [self requestURL:DWRequestTypeCurrent];
    
    NSDictionary *parameter =  [self SKPlanetAPILogitude:longitude village:village country:country foretxt:foretxt latitude:latitude city:city];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self addAppkey:manager];
    
    [manager GET:URLString parameters:parameter
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [DataSingleTon sharedDataSingleTon].currentData = responseObject;
            NSLog(@"CurrentData responseObject = %@",responseObject);
            UpdateDataBlock();
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"현재 온도 네트워크 연결 실패");
            
        }];
    
}


#pragma mark weekforecast
+ (void)requestWeekForecastDataLongitude:(NSString *)longitude village:(NSString *)village country:(NSString *)country foretxt:(NSString *)foretxt latitude:(NSString *)latitude city:(NSString *)city updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = [self requestURL:DWRequestTypeWeekForecast];
    
    NSDictionary *parameter =  [self SKPlanetAPILogitude:longitude village:village country:country foretxt:foretxt latitude:latitude city:city];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self addAppkey:manager];
    
    [manager GET:URLString parameters:parameter
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [DataSingleTon sharedDataSingleTon].weekForcastData = responseObject;
            NSLog(@"WeekForecast responseObject = %@",responseObject);
            
            UpdateDataBlock();
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"6일 예보 실패");
            
        }];
    
}



@end
