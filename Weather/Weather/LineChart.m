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
@property CGFloat maxValue;
@property CGFloat margin;

@end

@implementation LineChart

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.graphPoints = [[NSMutableArray alloc] initWithArray: @[ @4, @2, @6, @4, @5, @8, @3]];
        self.width = 0;
        self.height = 0;
        self.maxValue = 0;
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    self.width = rect.size.width;
    self.height = rect.size.height;
    
    if ( self.graphPoints == nil ) {
        self.graphPoints = [[NSMutableArray alloc] initWithArray: @[ @10, @0, @20, @10, @0, @20, @10]];
    }
    
    UIColor *starColor = [UIColor clearColor];
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
    CGFloat colorLocations[] = { 0.0f,1.0f };
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations);
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(0, self.bounds.size.height);
    
    // draw graph line
    
    [[UIColor whiteColor] setFill];
    [[UIColor whiteColor] setStroke];
    
    UIBezierPath *graphPath = [[UIBezierPath alloc] init];
    [graphPath moveToPoint:CGPointMake( [self columnXPoint:0] ,
                                       [self columnYPoint: [self.graphPoints[0] integerValue]])];
    
    for ( NSInteger i = 1; i < self.graphPoints.count; i++ ) {
        
        CGPoint nextPoint = CGPointMake([self columnXPoint:i], [self columnYPoint: [self.graphPoints[i] integerValue]]);
        [graphPath addLineToPoint:nextPoint];
    }
    
    graphPath.lineWidth = 2.0;
    [graphPath stroke];
    
    
    // temperate Text draw
    
    for ( NSInteger i =0; i < self.graphPoints.count; i++ ) {
        
        NSString * temperate = [[NSString alloc] initWithFormat:@"%ld°",[self.graphPoints[i] integerValue]];
        [temperate drawAtPoint:CGPointMake([self columnXPoint:i], [self columnYPoint: [self.graphPoints[i] integerValue]] - 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    // graphDownLine Area gradient
    
    UIBezierPath *clippingPath = graphPath.copy;
    [clippingPath addLineToPoint:CGPointMake([self columnXPoint:self.graphPoints.count -1 ], self.height)];
    [clippingPath addLineToPoint:CGPointMake([self columnXPoint:0], self.height-10)];
    
    [clippingPath closePath];
    [clippingPath addClip];
    
    CGFloat highestYPoint = [self columnYPoint:self.maxValue];
    startPoint = CGPointMake(self.margin, highestYPoint);
    endPoint = CGPointMake(self.margin, self.bounds.size.height-10);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // graphLine
    
    UIBezierPath *weatherLine = graphPath.copy;
    
    [weatherLine moveToPoint:CGPointMake([self columnXPoint:6], [self columnYPoint: [self.graphPoints[6] integerValue]])];
    [weatherLine addLineToPoint:CGPointMake([self columnXPoint:6], self.height-10)];
    weatherLine.lineWidth = 0.5;
    [weatherLine stroke];
    
}

- (CGFloat)columnXPoint:(NSInteger)countNumber {
    
    self.margin = 20.0;
    CGFloat spacer = (self.width - self.margin*2 -4) / (self.graphPoints.count - 1);
    CGFloat x = countNumber * spacer;
    x += self.margin + 2;
    
    return x;
    
}

- (CGFloat)columnYPoint:(NSInteger)countNumber {
    
    CGFloat topBorder = 60;
    CGFloat bottomBorder = 50;
    CGFloat graphHeight = self.height - topBorder - bottomBorder;
    self.maxValue = 0;
    
    for ( NSInteger i = 0; i < self.graphPoints.count; i ++) {
        
        NSNumber *number = self.graphPoints[i];
        
        if ( self.maxValue < [number integerValue] ) {
            self.maxValue = [number integerValue];
        }
    }
    
    CGFloat y = countNumber / self.maxValue * graphHeight;
    y = graphHeight + topBorder - y;
    
    return y;
}


@end
