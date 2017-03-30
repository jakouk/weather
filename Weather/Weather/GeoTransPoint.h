//
//  GeoTransPoint.h
//  FEvent
//
//  Created by jinuk son on 13. 3. 14..
//  Copyright (c) 2013년 DANAL. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GeoTransPoint : NSObject {
    
}

@property(nonatomic,readwrite)double x;
@property(nonatomic,readwrite)double y;
@property(nonatomic,readwrite)double z;


-(void) GeoTransPoint2:(double) _x Y:(double) _y;
-(void) GeoTransPoint3:(double) _x Y:(double) _y Z:(double)_z ;

-(double) getX;
-(double) getY ;



@end
