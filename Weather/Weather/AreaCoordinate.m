//
//  areaCoordinate.m
//  Weather
//
//  Created by jakouk on 2017. 4. 10..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "AreaCoordinate.h"

#define NX  149     /* X축 격자점 수 */
#define NY  253     /* Y축 격자점 수 */


@implementation AreaCoordinate

- (NSDictionary *)areaCoordinate:(NSString *)latitude longitude:(NSString *)longitude {
    
    float  lon, lat;
    
    lon = [longitude floatValue];
    lat = [latitude floatValue];
    
    NSMutableDictionary *area = [self mapMove:lon latitude:lat];
    
    return area;
}

- (NSMutableDictionary *)mapMove:(float)lon latitude:(float)lat {

    NSNumber *x1, *y1;
    NSMutableDictionary *coordinate = [self lamcproj:lon latitude:lat];
    
    x1 = coordinate[@"x"];
    y1 = coordinate[@"y"];
    
    int x = (int)([x1 floatValue] + 1.5);
    int y = (int)([y1 floatValue] + 1.5);
    
    NSNumber *xCoordinate = [[NSNumber alloc] initWithInt:x];
    NSNumber *yCoordinate = [[NSNumber alloc] initWithInt:y];
    
    [coordinate setValue:xCoordinate forKey:@"x"];
    [coordinate setValue:yCoordinate forKey:@"y"];
    
    
    return coordinate;
}

- (NSMutableDictionary *)lamcproj:(float)lon latitude:(float)lat {
    
    
    NSMutableDictionary *lamcproj = [[NSMutableDictionary alloc] init];
    
    double  PI, DEGRAD, RADDEG;
    double  re, olon, olat, sn, sf, ro;
    double slat1, slat2, ra, theta, xn, yn;
    
    PI = asin(1.0)*2.0;
    DEGRAD = PI/180.0;
    RADDEG = 180.0/PI;
        
    re = 6371.00877/5.0;
    slat1 = 30.0 * DEGRAD;
    slat2 = 60.0 * DEGRAD;
    olon = 126 * DEGRAD;
    olat = 38 * DEGRAD;
        
    sn = tan(PI*0.25 + slat2*0.5)/tan(PI*0.25 + slat1*0.5);
    sn = log(cos(slat1)/cos(slat2))/log(sn);
    sf = tan(PI*0.25 + slat1*0.5);
    sf = pow(sf,sn)*cos(slat1)/sn;
    ro = tan(PI*0.25 + olat*0.5);
    ro = re*sf/pow(ro,sn);
    
    ra = tan(PI*0.25+(lat)*DEGRAD*0.5);
    ra = re*sf/pow(ra,sn);
    theta = (lon)*DEGRAD - olon;
    if (theta >  PI) theta -= 2.0*PI;
    if (theta < -PI) theta += 2.0*PI;
    theta *= sn;
    
    xn = (float)(ra*sin(theta)) + 210/5;
    yn = (float)(ro - ra*cos(theta)) + 675/5;
    
    NSNumber *x = [[NSNumber alloc] initWithFloat:xn];
    NSNumber *y = [[NSNumber alloc] initWithFloat:yn];
    
    [lamcproj setValue:y forKey:@"y"];
    [lamcproj setValue:x forKey:@"x"];
    
    return lamcproj;
    
    
}

@end
