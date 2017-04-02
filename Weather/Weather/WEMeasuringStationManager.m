//
//  WEMeasuringStationManager.m
//  Weather
//
//  Created by jakouk on 2017. 3. 31..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WEMeasuringStationManager.h"

@implementation WEMeasuringStationManager

+ (void)requestMeasureStationData:(NSDictionary *)param updateDataBlock:(UpdateDataBlock)UpdateDataBlock {
    
    NSString *URLString = [self requestURL:RequestTypeMeasure];
    NSString *URLServiceString = [self addServiceKey:URLString];
    
    NSURL *url = [self URLStringToURL:URLServiceString parameter:param];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/xml"];
    
    NSLog(@"URL = %@",url);
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if ( !error ) {
            
            // success
            NSString *fetchedXML = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
            
            NSArray *firstStationArray = [fetchedXML componentsSeparatedByString:@"</stationName>"];
            NSString *item = firstStationArray[0];
            NSArray *stationArray = [item componentsSeparatedByString:@"<stationName>"];
            NSString *station = stationArray[1];
            
            [DataSingleTon sharedDataSingleTon].mesureStation = station;
             UpdateDataBlock();
            
        } else {
            
            // failure
            NSLog(@"error = %@",error);
            
        }
        
    }];
    
    [task resume];
    
}

@end
