//
//  customNavigationView.h
//  Weather
//
//  Created by jakouk on 2017. 4. 11..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customNavigationView : UIView

@property (weak, nonatomic) IBOutlet UIButton *sideBarMenu;
@property (weak, nonatomic) IBOutlet UIButton *regionAdd;

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
