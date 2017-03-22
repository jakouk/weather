//
//  ViewController.m
//  Weather
//
//  Created by jakouk on 2017. 3. 1..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MainWeatherView.h"
#import "LineChart.h"
#import "WEForecastManager.h"
#import "WECurrentManager.h"
#import "WEWeekRequest.h"
#import "MainView.h"
#import "WeekForecast.h"

@interface ViewController () <UIScrollViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property NSString *latitude;
@property NSString *longitude;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.alphaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    
    self.scrollView.delegate = self;
    
    // Location Manager 생성
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Location Receiver 콜백에 대한 delegate 설정
    self.locationManager.delegate = self;
    
    // 사용중에만 위치 정보 요청
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    // Location Manager 시작하기
    [self.locationManager startUpdatingLocation];
    
    self.latitude = [[NSString alloc] initWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
    CGFloat longitude = (-1) * self.locationManager.location.coordinate.longitude;
    self.longitude = [[NSString alloc] initWithFormat:@"%lf",longitude];
    
    NSDictionary *data = @{@"lon":self.longitude,@"village":@"",@"country":@"",@"foretxt":@"",@"lat":self.latitude,@"city":@""};
    
    
    __block ViewController *wself = self;
    
    [WECurrentManager requestCurrenttData:data updateDataBlock:^{
        
        [WEForecastManager requestForecastData:data updateDataBlock:^{
            
            [WEWeekRequest requestWeekForcastData:data updateDataBlock:^{
                
                [wself mainViewReload];
                [wself lineChartViewReload];
                [wself weekDataReload];
                
                
            }];
            
        }];
        
    }];
    
    NSTimeZone *timezone = [NSTimeZone localTimeZone];
    NSLog(@"timezone = %@",timezone);
    
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
    mainView.frame = CGRectMake(0, self.scrollView.frame.size.height/3 * 2 - 20 , self.scrollView.frame.size.width, self.scrollView.frame.size.height/3);
    
    NSDictionary *currentData = [DataSingleTon sharedDataSingleTon].currentData;

    NSDictionary *weatehr = currentData[@"weather"];
    NSArray *minutely = weatehr[@"minutely"];
    NSDictionary *minutelyFirstObject = minutely[0];
    
    NSDictionary *temperature = minutelyFirstObject[@"temperature"];
    NSDictionary *sky = minutelyFirstObject[@"sky"];
    NSDictionary *station = minutelyFirstObject[@"station"];
    
    NSLog(@"station = %@",station[@"name"]);
    
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
    
    
    
    LineChart * name = [[LineChart alloc] init];
    name.frame = CGRectMake(0, self.scrollView.frame.size.height + 20, self.scrollView.frame.size.width, self.scrollView.frame.size.height / 3);
    name.graphPoints = temperatureArray;
    // [name setNeedsDisplay];
    
    [name performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:0 waitUntilDone:NO];
    [self.scrollView addSubview:name];

}

- (void)weekDataReload {
    
    WeekForecast *weekForcast = [[WeekForecast alloc] init];
    weekForcast.frame = CGRectMake(0, self.scrollView.frame.size.height +20 + self.scrollView.frame.size.height / 3 + 10, self.scrollView.frame.size.width, self.scrollView.frame.size.height/ 3);
    
    
    NSDictionary *weekForcastData = [DataSingleTon sharedDataSingleTon].weekForcastData;
    NSDictionary *weather = weekForcastData[@"weather"];
    NSArray *forecast6days = weather[@"forecast6days"];
    NSDictionary *forecast6daysFirst = forecast6days[0];
    NSDictionary *sky = forecast6daysFirst[@"sky"];
    
    NSMutableArray *forecast6daysArray = [[NSMutableArray alloc] init];
    NSMutableArray *forecaset6daysSkyArray = [[NSMutableArray alloc] init];
    
    NSMutableString *dayWeather = [[NSMutableString alloc] init];
    NSMutableString *dayWeatherImageName = [[NSMutableString alloc] init];
    NSMutableString *skySplitFirst = [[NSMutableString alloc] init];
    
    
    NSString *amCode = @"amCode";
    NSString *day = @"day";
    NSString *threeSize = @"-3";
    
    NSString *weatherImage = @"";
    
    
    for ( NSInteger i = 2; i < 8; i++ ) {
        
        [dayWeather appendString:amCode];
        [dayWeather appendFormat:@"%ld",i];
        [dayWeather appendString:day];
        
        NSString *skyw = sky[dayWeather];
        [forecaset6daysSkyArray addObject:skyw];
        
    }
    
    for ( NSInteger i = 0; i < forecaset6daysSkyArray.count; i++ ) {
        
        NSArray *skywSplit = [forecaset6daysSkyArray[i] componentsSeparatedByString:@"W"];
        //NSLog(@"%@,%@",skywSplit[1], [skywSplit[1] class]);
        [skySplitFirst appendFormat:@"%@",skywSplit[1]];
        
        [dayWeatherImageName appendFormat:@"%@",skySplitFirst];
        [dayWeatherImageName appendString:threeSize];
        
        NSLog(@"dayWeatherImageName = %@",dayWeatherImageName);
        
        weatherImage = dayWeatherImageName;
        
        [forecast6daysArray addObject:weatherImage];
        NSLog(@"forcast6daysArray = %@",forecast6daysArray);
        
        [dayWeatherImageName setString:@""];
        [dayWeather setString:@""];
        [skySplitFirst setString:@""];
        weatherImage = @"";
        
    }
    
    NSLog(@"forcast6daysArray = %@",forecast6daysArray);
    
    weekForcast.weekdayWeather = forecast6daysArray;
    
    [weekForcast setNeedsDisplay];
    [self.scrollView addSubview:weekForcast];
    
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
