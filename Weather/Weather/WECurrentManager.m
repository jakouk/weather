//
//  WECurrentManager.m
//  Weather
//
//  Created by jakouk on 2017. 3. 7..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WECurrentManager.h"
#import "DataSingleTon.h"

@implementation WECurrentManager

+ (void)requestCurrenttData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = [self requestURL:RequestTypeCurrent];
    
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

@end
