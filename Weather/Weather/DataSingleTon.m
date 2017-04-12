//
//  DataSingleTon.m
//  Weather
//
//  Created by jakouk on 2017. 3. 4..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "DataSingleTon.h"

@implementation DataSingleTon

+ (instancetype)sharedDataSingleTon {
    
    static DataSingleTon *data = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (data == nil) {
            data = [[DataSingleTon alloc] init];
        }
    });
    
    return data;
}

@end
