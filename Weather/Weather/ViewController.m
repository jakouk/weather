//
//  ViewController.m
//  Weather
//
//  Created by jakouk on 2017. 3. 1..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "ViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "MainWeatherView.h"
#import "LineChart.h"
#import "WEForecastManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    
    NSDictionary *data = @{@"lon":@"37",@"village":@"",@"country":@"",@"foretxt":@"",@"lat":@"127",@"city":@"",@"version":@"1"};
    
    __block ViewController *wself = self;
    
    [WEForecastManager requestForecastData:data updateDataBlock:^{
        
        [wself viewReload];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewReload {
    
    MainWeatherView *mainChart = [[[NSBundle mainBundle] loadNibNamed:@"MainWeatherView" owner:self options:nil] firstObject];
    
    LineChart *tempara;
    
    NSDictionary *forecastData = [DataSingleTon sharedDataSingleTon].forecastData;
    NSDictionary *weather = forecastData[@"weather"];
    NSArray *forcast3Datas = weather[@"forecast3days"];
    
    NSLog(@"forcast3Datas Array %@",forcast3Datas);
    
    NSDictionary *forcast3DatasFirstObject = forcast3Datas[0];
    NSDictionary *fcst3hour = forcast3DatasFirstObject[@"fcst3hour"];
    NSDictionary *temperature = fcst3hour[@"temperature"];
    
    NSLog(@"temperature = %@",temperature);
    
    NSMutableArray *temperatureArray = [[NSMutableArray alloc] init];
    
    NSString *temp = @"temp";
    NSString *hour = @"hour";
    
    
    
    
    
    
    for (NSInteger i = 4; i < 43; i+= 3) {
        
        NSMutableString *key = [[NSMutableString alloc] init];
        [key appendString:temp];
        [key appendFormat:@"%ld",i];
        [key appendString:hour];
        
        NSNumber *number = temperature[key];
        
        [temperatureArray addObject:number];
    }
    
    NSLog(@"temporatureArray = %@",temperatureArray);
    
    
    for ( UIView *subView in [mainChart subviews]) {
        
        if ( subView.tag == 1) {
            
            NSLog(@"%@",subView);
            
            for ( UIView *subViewSub in [subView subviews]) {
                
                if ( [subViewSub isKindOfClass:[LineChart class]]) {
                    tempara = (LineChart *)subViewSub;
                }
            }
        }
    }
    
    if (tempara != nil) {
        
        tempara.graphPoints = temperatureArray;
        [tempara setNeedsDisplay];
    }
    
    [self.scrollView addSubview:mainChart];
    
}


@end
