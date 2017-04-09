//
//  MainWeatherView.m
//  Weather
//
//  Created by jakouk on 2017. 3. 2..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "MainWeatherView.h"


@interface MainWeatherView ()

@end

@implementation MainWeatherView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    
//}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if (self) {
            UIView *xibView = [[[NSBundle mainBundle] loadNibNamed:@"MainWeatherView"
                                                             owner:self
                                                           options:nil] objectAtIndex:0];
            xibView.frame = self.bounds;
            xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self addSubview: xibView];
        }
        
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView *xibView = [[[NSBundle mainBundle] loadNibNamed:@"MainWeatherView"
                                                         owner:self
                                                       options:nil] objectAtIndex:0];
        xibView.frame = self.bounds;
        xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: xibView];
    }
    
    return self;
    
}







@end
