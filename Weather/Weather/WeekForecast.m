//
//  WeekForecast.m
//  Weather
//
//  Created by jakouk on 2017. 3. 13..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "WeekForecast.h"

@implementation WeekForecast

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor whiteColor] setFill];
    [[UIColor whiteColor] setStroke];
    
    UIBezierPath *weekForcastPath = [[UIBezierPath alloc] init];
    
    [weekForcastPath moveToPoint:CGPointMake(20, 0)];
    [weekForcastPath addLineToPoint:CGPointMake(rect.size.width - 20, 0)];
    
    weekForcastPath.lineWidth = 1.0;
    [weekForcastPath stroke];
    
    NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    NSArray *dayArray = [self weekDayReturnKorean:component.weekday];
    NSArray *splitArray;
    
    NSMutableString *imageName = [[NSMutableString alloc] init];
    NSString *three = @"-3";
    
    for ( NSInteger i = 0; i < dayArray.count; i++) {
        
        NSString *weekDay = dayArray[i];
        
        [weekDay drawAtPoint:CGPointMake(25, (rect.size.height / dayArray.count) * i + 25 ) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [@"AM" drawAtPoint:CGPointMake(rect.size.width/6 + 15, (rect.size.height / dayArray.count) * i + 25 ) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [@"PM" drawAtPoint:CGPointMake(rect.size.width/2.2 + 4 , (rect.size.height / dayArray.count) * i + 25 ) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        
        if ( self.weekdayAmWeather != nil ) {

            if ( self.weekdayPmWeather != nil ) {
                
                [weekForcastPath moveToPoint:CGPointMake(20, (rect.size.height / dayArray.count) * (i + 1))];
                [weekForcastPath addLineToPoint:CGPointMake(rect.size.width - 20, (rect.size.height / dayArray.count) * (i + 1))];
                
                splitArray = [self.weekdayAmWeather[i] componentsSeparatedByString:@"W"];
                NSString *weekDayAmWeather = splitArray[1];
                
                [imageName appendString:weekDayAmWeather];
                [imageName appendString:three];
                
                [[UIImage imageNamed:imageName] drawAtPoint: CGPointMake(((rect.size.width - 20) / 3.8), (rect.size.height / dayArray.count) * i)];
                
                [imageName setString:@""];
                
                splitArray = [self.weekdayPmWeather[i] componentsSeparatedByString:@"W"];
                NSString *weekDayPmWeather = splitArray[1];
                
                [imageName appendString:weekDayPmWeather];
                [imageName appendString:three];
                
                [[UIImage imageNamed:imageName] drawAtPoint: CGPointMake(((rect.size.width - 20) / 2) + 15 , (rect.size.height / dayArray.count) * i)];
                
                [imageName setString:@""];
            }
            
        }
        
        
        NSString *tmax = [[NSString alloc] initWithFormat:@"%@°",_weekdayMax[i]];
        NSString *tmin = [[NSString alloc] initWithFormat:@"%@°",_weekdayMin[i]];
        
        [tmax drawAtPoint:CGPointMake(rect.size.width/2 + rect.size.width/4, (rect.size.height / dayArray.count) * i + 25 ) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [tmin drawAtPoint:CGPointMake(rect.size.width - rect.size.width/10, (rect.size.height / dayArray.count) * i + 25 ) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:20],NSForegroundColorAttributeName:[UIColor colorWithRed:0.38 green:0.50 blue:0.60 alpha:1.00]}];
    }
    
    
    [[UIColor whiteColor] setFill];
    [[UIColor whiteColor] setStroke];
    weekForcastPath.lineWidth = 0.25;
    [weekForcastPath stroke];
    
}

- (NSArray *)weekDayReturnKorean:(NSInteger)componentWeekDay {
    
    NSString *weekday = [[NSString alloc] init];
    NSMutableArray *weekDayArray = [[NSMutableArray alloc] init];
    
    componentWeekDay += 2;
    
    if ( componentWeekDay >= 8) {
        
        componentWeekDay -= 7;
    }
    
    for ( NSInteger i = 0; i < 6; i ++ ) {
        
        switch (componentWeekDay) {
            case 1:
                weekday = @"일요일";
                break;
            case 2:
                weekday = @"월요일";
                break;
            case 3:
                weekday = @"화요일";
                break;
            case 4:
                weekday = @"수요일";
                break;
            case 5:
                weekday = @"목요일";
                break;
            case 6:
                weekday = @"금요일";
                break;
            case 7:
                weekday = @"토요일";
                break;
        }
        
        componentWeekDay += 1;
        
        if ( componentWeekDay > 7 ) {
            
            componentWeekDay = 1;
        }
        
        [weekDayArray addObject:weekday];
        
    }
    
    return weekDayArray;
}

@end
