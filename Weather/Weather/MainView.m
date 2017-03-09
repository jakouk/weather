//
//  MainView.m
//  Weather
//
//  Created by jakouk on 2017. 3. 6..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat height = rect.size.height;
    
    [[UIImage imageNamed:@"Up-50"] drawAtPoint:CGPointMake(20,height/9 * 4)];
    [[UIImage imageNamed:@"Down-50"] drawAtPoint:CGPointMake(110, height/9 * 4)];
    [[UIImage imageNamed:self.weatherImageName] drawAtPoint:CGPointMake(20, height/9 * 1 - 20)];
    
    // current Temperature
    NSString *temperature = [[NSString alloc] initWithFormat:@"%@°",_currentTemper];
    [temperature drawAtPoint:CGPointMake(20, (height/9 * 5)) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:100.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // maxTemper
    NSString *maxTemper = [[NSString alloc] initWithFormat:@"%@°",_maxTemper];
    [maxTemper drawAtPoint:CGPointMake(65, (height/9 * 4) + 15) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:20.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // minTemper
    NSString *minTemper = [[NSString alloc] initWithFormat:@"%@°",_miniTemper];
    [minTemper drawAtPoint:CGPointMake(150, (height/9 * 4) + 10) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:20.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // wwatherName
    [self.weatherName drawAtPoint:CGPointMake(130, (height/9 * 3) - 15) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:25.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

@end
