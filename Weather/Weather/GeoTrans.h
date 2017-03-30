//
//  GeoTrans.h
//  FEvent
//
//  Created by jinuk son on 13. 3. 14..
//  Copyright (c) 2013년 DANAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeoTransPoint.h"

#define GEO 0
#define KATEC 1
#define TM 2
#define GRS80 3
#define EPSLN 0.0000000001

@interface GeoTrans : NSObject {
    double m_Ind [3];
    double m_Es [3];
    double m_Esp [3];
    double src_m [3];
    double dst_m [3];
    
    double m_arMajor [3];
    double m_arMinor [3];
    
    double m_arScaleFactor [3];
    double m_arLonCenter [3];
    double m_arLatCenter [3];
    double m_arFalseNorthing [3];
    double m_arFalseEasting [3];
    
    double datum_params [3];
    
}

-(void)initValue;
-(GeoTransPoint *) convert:(int) srctype DST:(int)dsttype GEOIN:(GeoTransPoint*) in_pt;

@end
