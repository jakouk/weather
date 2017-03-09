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
#import "WECurrentManager.h"
#import "MainView.h"

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *alphaView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.alphaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    
    self.scrollView.delegate = self;
    
    NSDictionary *data = @{@"lon":@"37",@"village":@"",@"country":@"",@"foretxt":@"",@"lat":@"127",@"city":@""};
    
    __block ViewController *wself = self;
    
    [WECurrentManager requestCurrenttData:data updateDataBlock:^{
        
        [WEForecastManager requestForecastData:data updateDataBlock:^{
            
            [wself mainViewReload];
            [wself lineChartViewReload];
        }];
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// scroll background alpha
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if ( scrollView.contentOffset. y < 400 ) {
        
        CGFloat alpha = 0;
        alpha = scrollView.contentOffset.y / 600;
        self.alphaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
        
    }
    
}



- (void)mainViewReload {
    
    MainView *mainView = [[MainView alloc] init];
    mainView.frame = CGRectMake(0, self.scrollView.frame.size.height/3 * 2, self.scrollView.frame.size.width, self.scrollView.frame.size.height/3);
    
    NSDictionary *currentData = [DataSingleTon sharedDataSingleTon].currentData;

    NSDictionary *weatehr = currentData[@"weather"];
    NSArray *minutely = weatehr[@"minutely"];
    NSDictionary *minutelyFirstObject = minutely[0];
    
    NSDictionary *temperature = minutelyFirstObject[@"temperature"];
    
    NSDictionary *sky = minutelyFirstObject[@"sky"];
    NSString *skyMin = sky[@"code"];
    NSString *skyName = sky[@"name"];
    NSString *skyIn = [skyMin substringFromIndex:5];
    
    mainView.weatherImageName = skyIn;
    mainView.weatherName = skyName;
    mainView.currentTemper = temperature[@"tc"];
    mainView.maxTemper = temperature[@"tmax"];
    mainView.miniTemper = temperature[@"tmin"];
    
    [mainView setNeedsDisplay];
    
    [self.scrollView addSubview:mainView];
    
}


- (void)lineChartViewReload {
    
    MainWeatherView *mainChart = [[[NSBundle mainBundle] loadNibNamed:@"MainWeatherView" owner:self options:nil] firstObject];
    
    LineChart *tempara;
    
    NSDictionary *forecastData = [DataSingleTon sharedDataSingleTon].forecastData;
    NSDictionary *weather = forecastData[@"weather"];
    NSArray *forcast3Datas = weather[@"forecast3days"];
    
    NSDictionary *forcast3DatasFirstObject = forcast3Datas[0];
    NSDictionary *fcst3hour = forcast3DatasFirstObject[@"fcst3hour"];
    
    NSDictionary *temperature = fcst3hour[@"temperature"];
    
    NSDictionary *sky = fcst3hour[@"sky"];
    
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
    
    
    NSMutableArray *skyArray = [[NSMutableArray alloc] init];
    NSString *code = @"code";
    
    for (NSInteger i = 4; i< 43; i += 3) {
        
        NSMutableString *key = [[NSMutableString alloc] init];
        [key appendString:code];
        [key appendFormat:@"%ld",i];
        [key appendString:hour];
        
        NSString *weatherSky = sky[key];
        [skyArray addObject:weatherSky];
    }
    
    
    for ( UIView *subView in [mainChart subviews]) {
        
        if ( subView.tag == 1) {

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
    
    
    // [self.scrollView addSubview:mainChart];
    
    LineChart * name = [[LineChart alloc] init];
   
    name.frame = CGRectMake(0, self.scrollView.frame.size.height + 20, self.scrollView.frame.size.width-20, self.scrollView.frame.size.height / 4);
    
    name.graphPoints = temperatureArray;
    [name setNeedsDisplay];
    [self.scrollView addSubview:name];

}

- (NSArray *)temperateDataReturn:(NSString *)apiKey {
    
    NSDictionary *forecastData = [DataSingleTon sharedDataSingleTon].forecastData;
    NSDictionary *weather = forecastData[@"weather"];
    NSArray *forcast3Datas = weather[@"forecast3days"];
    
    NSDictionary *forcast3DatasFirstObject = forcast3Datas[0];
    NSDictionary *fcst3hour = forcast3DatasFirstObject[@"fcst3hour"];
    
    NSDictionary *temperature = fcst3hour[@"temperature"];
    NSDictionary *sky = fcst3hour[@"sky"];
    
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
    
    NSMutableArray *skyArray = [[NSMutableArray alloc] init];
    NSString *code = @"code";
    
    for (NSInteger i = 4; i< 43; i += 3) {
        
        NSMutableString *key = [[NSMutableString alloc] init];
        [key appendString:code];
        [key appendFormat:@"%ld",i];
        [key appendString:hour];
        NSLog(@"key = %@",key);
        
        NSString *weatherSky = sky[key];
        [skyArray addObject:weatherSky];
    }
    
    return temperatureArray;
    
}


@end
