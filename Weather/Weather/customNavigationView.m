//
//  customNavigationView.m
//  Weather
//
//  Created by jakouk on 2017. 4. 11..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "customNavigationView.h"

@implementation customNavigationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView *xibView = [[[NSBundle mainBundle] loadNibNamed:@"customNavigationView"
                                                         owner:self
                                                       options:nil] objectAtIndex:0];
        xibView.frame = self.bounds;
        xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: xibView];
    }
    
    return self;
    
}


@end
