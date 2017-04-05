//
//  WEDustManager.m
//  Weather
//
//  Created by jakouk on 2017. 3. 31..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WEDustManager.h"

@implementation WEDustManager

+ (void)requestDustData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = [self requestURL:RequestTypeDust];
    NSString *URLServiceString = [self addServiceKey:URLString];
    NSURL *url = [self URLStringToURL:URLServiceString parameter:param];
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
            NSDictionary *dustDataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
            
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
