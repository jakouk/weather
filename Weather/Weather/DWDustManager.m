//
//  DWDustManager.m
//  Weather
//
//  Created by jakouk on 2017. 4. 7..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "DWDustManager.h"

@implementation DWDustManager

+ (void)requestWGS84ToTM:(NSString *)latitude longitude:(NSString *)longitude updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = [self requestURL:DWRequestTypeTM];
    NSDictionary *parameter = @{@"y":latitude,@"x":longitude};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *URLApiString = [self addApiKey:URLString];
    
    [manager GET:URLApiString parameters:parameter
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [DataSingleTon sharedDataSingleTon].TMData = responseObject;
            UpdateDataBlock();
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            NSLog(@"%@",error);
            NSLog(@"TM 위치 데이터 실패 ");
            
        }];
    
}


+ (void)requestMeasureStationData:(NSString *)tmX yCoordinate:(NSString *)tmY updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = [self requestURL:DWRequestTypeMeasure];
    NSString *URLServiceString = [self addServiceKey:URLString];
    
    NSDictionary *parameter = @{@"tmX":tmX,@"tmY":tmY};
    
    NSURL *url = [self URLStringToURL:URLServiceString parameter:parameter];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if ( !error ) {
            
            // success
            NSString *htmltoNSString = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
            
            NSData *jsonData = [htmltoNSString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *e;
            NSDictionary *mesureStationDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
            
            
            [DataSingleTon sharedDataSingleTon].mesureStation = mesureStationDic;
            UpdateDataBlock();
            
        } else {
            
            // failure
            NSLog(@"error = %@",error);
            
        }
        
    }];
    
    [task resume];
    
}


+ (void)requestDustData:(NSString *)station updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = [self requestURL:DWRequestTypeDust];
    NSString *URLServiceString = [self addServiceKey:URLString];
    
    NSDictionary *parameter = @{@"stationName":[station stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]};
    
    NSURL *url = [self URLStringToURL:URLServiceString parameter:parameter];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if ( !error ) {
            
            // success
            NSString *htmltoNSString = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
            
            NSData *jsonData = [htmltoNSString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *e;
            NSDictionary *dustDataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
            
            [DataSingleTon sharedDataSingleTon].dustData = dustDataDic;
            UpdateDataBlock();
            
        } else {
            
            // failure
            NSLog(@"error = %@",error);
            
        }
        
    }];
    
    [task resume];
    
}


@end
