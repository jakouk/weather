//
//  LineChart.m
//  Weather
//
//  Created by jakouk on 2017. 3. 1..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "LineChart.h"


@interface LineChart ()

@property CGFloat width;
@property CGFloat height;

@end


@implementation LineChart

- (instancetype)init {
    
    self.graphPoints = [[NSMutableArray alloc] initWithArray: @[ @4, @2, @6, @4, @5, @8, @3]];
    self.width = 0;
    self.height = 0;
    
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    self.width = rect.size.width;
    self.height = rect.size.height;
    
    if ( self.graphPoints == nil ) {
        self.graphPoints = [[NSMutableArray alloc] initWithArray: @[ @4, @2, @6, @4, @5, @8, @3]];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
    [path addClip];

    
    UIColor *starColor = [UIColor redColor];
    UIColor *endColor = [UIColor grayColor];
    
    // get the current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set up the color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // set up the color stops
    CFMutableArrayRef colors = CFArrayCreateMutable(NULL, 2, &kCFTypeArrayCallBacks);
    CFArrayAppendValue(colors, starColor.CGColor);
    CFArrayAppendValue(colors, endColor.CGColor);
    
    // create the gradient
    CGFloat colorLocations[] = { 0.0f, 1.0f };
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations);
    
    
    
    
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(0, self.bounds.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);

    
    [[UIColor whiteColor] setFill];
    [[UIColor whiteColor] setStroke];
    
    
    UIBezierPath *graphPath = [[UIBezierPath alloc] init];
    [graphPath moveToPoint:CGPointMake( [self columnXPoint:0] ,
                                       [self columnYPoint: [self.graphPoints[0] integerValue]])];
    
    for ( NSInteger i = 1; i < self.graphPoints.count; i++ ) {
        
        CGPoint nextPoint = CGPointMake([self columnXPoint:i], [self columnYPoint: [self.graphPoints[i] integerValue]]);
        
        NSLog(@" x = %lf",nextPoint.x);
        NSLog(@" y = %lf",nextPoint.y);
        
        [graphPath addLineToPoint:nextPoint];
    }
    
    graphPath.lineWidth = 2.0;
    [graphPath stroke];
    
    
}

- (CGFloat)columnXPoint:(NSInteger)countNumber {
    
    CGFloat margin = 20.0;
    CGFloat spacer = (self.width - margin*2 -4) / self.graphPoints.count - 1;
    CGFloat x = countNumber * spacer;
    x += margin + 2;
    
    return x;
    
}

- (CGFloat)columnYPoint:(NSInteger)countNumber {
    
    CGFloat topBorder = 60;
    CGFloat bottomBorder = 50;
    CGFloat graphHeight = self.height - topBorder - bottomBorder;
    CGFloat maxValue = 0;
    
    
    for ( NSInteger i = 0; i < self.graphPoints.count; i ++) {
        
        NSNumber *number = self.graphPoints[i];
        
        if ( maxValue < [number integerValue] ) {
            
            maxValue = [number integerValue];
        }
    }
    
    CGFloat y = countNumber / maxValue * graphHeight;
    y = graphHeight + topBorder - y;
    
    return y;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
