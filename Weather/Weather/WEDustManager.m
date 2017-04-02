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
    
    NSLog(@"DustManager URLString = %@\n\n",URLServiceString);
    
    NSURL *url = [super URLStringToURL:URLServiceString parameter:param];
    
    NSLog(@"Dust Manager url = %@\n\n",url.absoluteString);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/xml"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if ( !error ) {
            
            // success
            NSString *fetchedXML = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"fetchedXML = %@",fetchedXML);
            
        } else {
            
            // failure
            NSLog(@"error = %@",error);
            
        }
        
    }];
    
    [task resume];
    
}

@end
