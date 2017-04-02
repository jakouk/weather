//
//  WETMManager.m
//  Weather
//
//  Created by jakouk on 2017. 3. 31..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WETMManager.h"

@implementation WETMManager

+ (void)requestWeekForcastData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = [self requestURL:RequestTypeTM];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *URLApiString = [self addApiKey:URLString];
    
    [manager GET:URLApiString parameters:param
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [DataSingleTon sharedDataSingleTon].TMData = responseObject;
            UpdateDataBlock();
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            NSLog(@"%@",error);
            NSLog(@"TM 위치 데이터 실패 ");
            
        }];
    
}

@end
