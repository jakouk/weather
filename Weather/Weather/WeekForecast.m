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
    
    for ( NSInteger i = 0; i < dayArray.count; i++) {
        
        NSString *weekDay = dayArray[i];
        NSLog(@"weekDay = %@",weekDay);
        [weekDay drawAtPoint:CGPointMake(20, (rect.size.height / dayArray.count) * i + 10 ) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
    }
    
    
    
    
}

- (NSArray *)weekDayReturnKorean:(NSInteger)componentWeekDay {
    
    NSString *weekday = [[NSString alloc] init];
    NSMutableArray *weekDayArray = [[NSMutableArray alloc] init];
    
    componentWeekDay += 2;
    
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
