//
//  GeoTransPoint.m
//  FEvent
//
//  Created by jinuk son on 13. 3. 14..
//  Copyright (c) 2013년 DANAL. All rights reserved.
//



#import "GeoTransPoint.h"

@implementation GeoTransPoint

@synthesize x,y,z;

-(void) GeoTransPoint2:(double) _x Y:(double) _y {
 
    x = _x;
    y = _y;
    z = 0;
}

-(void) GeoTransPoint3:(double) _x Y:(double) _y Z:(double)_z {
    
    x = _x;
    y = _y;
    z = 0;
}

-(double) getX {
    return x;
}



-(double) getY {
    return y;
}

@end
