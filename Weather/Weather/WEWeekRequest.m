//
//  WEWeekRequest.m
//  Weather
//
//  Created by jakouk on 2017. 3. 21..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WEWeekRequest.h"

@implementation WEWeekRequest

+ (void)requestWeekForcastData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = [self requestURL:RequestTypeWeekForcast];
    
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

@end
