//
//  DustView.m
//  Weather
//
//  Created by jakouk on 2017. 4. 4..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "DustView.h"

@implementation DustView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    NSString *totalDust = self.dustDataDictionary[@"khaiValue"];
    NSDictionary *totalGradeDic = [self gradeSeperate:totalDust dustType:@"통합"];
    NSString *totalGrade = totalGradeDic[@"dustString"];
    UIColor *totalColor = totalGradeDic[@"dustColor"];
    
    [totalDust drawAtPoint:CGPointMake(20, 20) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:80.0],NSForegroundColorAttributeName:totalColor}];
    
    [totalGrade drawAtPoint:CGPointMake(200, 20) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:80.0],NSForegroundColorAttributeName:totalColor}];
    
    
    NSString *pm10Dust = self.dustDataDictionary[@"pm10Value"];
    NSDictionary *pm10GradeDic = [self gradeSeperate:pm10Dust dustType:@"미세"];
    NSString *pm10Grade = pm10GradeDic[@"dustString"];
    UIColor *pm10Color = pm10GradeDic[@"dustColor"];
    
    [pm10Dust drawAtPoint:CGPointMake(20, 20 + 70) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:80.0],NSForegroundColorAttributeName:pm10Color}];
    
    [pm10Grade drawAtPoint:CGPointMake(200, 20 + 70) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:80.0],NSForegroundColorAttributeName:pm10Color}];
    
    
    NSString *pm25Dust = self.dustDataDictionary[@"pm10Value"];
    NSDictionary *pm25GradeDic = [self gradeSeperate:pm10Dust dustType:@"초미세"];
    NSString *pm25Grade = pm25GradeDic[@"dustString"];
    UIColor *pm25Color = pm25GradeDic[@"dustColor"];
    
    [pm25Dust drawAtPoint:CGPointMake(20, 20 + 140) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:80.0],NSForegroundColorAttributeName:pm25Color}];
    
    [pm25Grade drawAtPoint:CGPointMake(200, 20 + 140) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:80.0],NSForegroundColorAttributeName:pm25Color}];
    
}


- (NSDictionary *)gradeSeperate:(NSString *)dustValue dustType:(NSString *)dustType {
    
    
    NSInteger gradeInteger = [dustValue integerValue];
    NSString *gradeString;
    UIColor *gradeColor;
    
    if ( [dustType isEqualToString:@"초미세"] ) {
        
        if ( gradeInteger <= 15 ) {
            
            gradeString = @"좋음";
            gradeColor = [UIColor blueColor];
            
        } else if ( gradeInteger <= 50 ) {
            
            gradeString = @"보통";
            gradeColor = [UIColor greenColor];
            
        } else if ( gradeInteger <= 100 ) {
            
            gradeString = @"나쁨";
            gradeColor = [UIColor orangeColor];
            
        } else {
            
            gradeString = @"매우 나쁨";
            gradeColor = [UIColor redColor];
            
        }
        
    } else {
        
        if ( gradeInteger <= 30 ) {
            
            gradeString = @"좋음";
            gradeColor = [UIColor blueColor];
            
        } else if ( gradeInteger <= 80 ) {
            
            gradeString = @"보통";
            gradeColor = [UIColor greenColor];
            
        } else if ( gradeInteger <= 150 ) {
            
            gradeString = @"나쁨";
            gradeColor = [UIColor orangeColor];
            
        } else {
            
            gradeString = @"매우 나쁨";
            gradeColor = [UIColor redColor];
            
        }
        
    }
    
    NSDictionary *grade = @{@"dustString":gradeString,@"dustColor":gradeColor};
    
    return grade;
    
}




@end
