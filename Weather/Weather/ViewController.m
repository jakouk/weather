//
//  ViewController.m
//  Weather
//
//  Created by jakouk on 2017. 3. 1..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
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

@property (nonatomic) UIRefreshControl *refreshControl;

@property NSString *latitude;
@property NSString *longitude;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.alphaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*3);
    
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
    
    NSLog(@"latitude %lf",self.locationManager.location.coordinate.latitude);
    NSLog(@"longitude %lf",self.locationManager.location.coordinate.longitude);
    
    self.latitude = [[NSString alloc] initWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
    CGFloat longitude = (-1) * self.locationManager.location.coordinate.longitude;
    self.longitude = [[NSString alloc] initWithFormat:@"%lf",longitude];
    
    NSTimeZone *timezone = [NSTimeZone localTimeZone];
    NSLog(@"timezone = %@",timezone);

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.refreshControl];
    
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


- (void)customViewReload {
    
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
    name.frame = CGRectMake(0, self.scrollView.frame.size.height + 20, self.scrollView.frame.size.width, self.scrollView.frame.size.height/2.5 );
    name.graphPoints = temperatureArray;
    // [name setNeedsDisplay];
    
    [name performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:0 waitUntilDone:NO];
    [self.scrollView addSubview:name];

}

- (void)weekDataReload {
    
    WeekForecast *weekForcast = [[WeekForecast alloc] init];
    weekForcast.frame = CGRectMake(0, self.scrollView.frame.size.height +20 + self.scrollView.frame.size.height / 2.5 + 10, self.scrollView.frame.size.width, (self.scrollView.frame.size.height / 3) * 2 );
    
    
    NSDictionary *weekForcastData = [DataSingleTon sharedDataSingleTon].weekForcastData;
    NSDictionary *weather = weekForcastData[@"weather"];
    NSArray *forecast6days = weather[@"forecast6days"];
    NSDictionary *forecast6daysFirst = forecast6days[0];
    NSDictionary *sky = forecast6daysFirst[@"sky"];
    NSDictionary *temperature = forecast6daysFirst[@"temperature"];
    
    
    NSMutableArray *forecast6daysAmArray = [[NSMutableArray alloc] init];
    NSMutableArray *forecast6daysPmArray = [[NSMutableArray alloc] init];
    
    NSMutableString *dayAmWeather = [[NSMutableString alloc] init];
    NSMutableString *dayPmWeather = [[NSMutableString alloc] init];
    
    
    NSString *amCode = @"amCode";
    NSString *pmCode = @"pmCode";
    NSString *day = @"day";
    
    
    for ( NSInteger i = 2; i < 8; i++ ) {
        
        [dayAmWeather appendString:amCode];
        [dayAmWeather appendFormat:@"%ld",i];
        [dayAmWeather appendString:day];
        
        [dayPmWeather appendString:pmCode];
        [dayPmWeather appendFormat:@"%ld",i];
        [dayPmWeather appendString:day];
        
        NSString *skyAm = sky[dayAmWeather];
        NSString *skyPm = sky[dayPmWeather];
        
        [forecast6daysAmArray addObject:skyAm];
        [forecast6daysPmArray addObject:skyPm];
        
        [dayAmWeather setString:@""];
        [dayPmWeather setString:@""];
        
    }
    
    NSMutableArray *tmaxArray = [[NSMutableArray alloc] init];
    NSMutableArray *tminArray = [[NSMutableArray alloc] init];
    
    NSMutableString *tMax = [[NSMutableString alloc] init];
    NSMutableString *tMin = [[NSMutableString alloc] init];
    
    NSString *tmax = @"tmax";
    NSString *tmin = @"tmin";
    
    for ( NSInteger i = 2; i < 8; i++ ) {
        
        [tMax appendString:tmax];
        [tMax appendFormat:@"%ld",i];
        [tMax appendString:day];
        
        [tMin appendString:tmin];
        [tMin appendFormat:@"%ld",i];
        [tMin appendString:day];
        
        [tmaxArray addObject:temperature[tMax]];
        [tminArray addObject:temperature[tMin]];
        
        [tMax setString:@""];
        [tMin setString:@""];
    }
    
    weekForcast.weekdayAmWeather = forecast6daysAmArray;
    weekForcast.weekdayPmWeather = forecast6daysPmArray;
    weekForcast.weekdayMax = tmaxArray;
    weekForcast.weekdayMin = tminArray;
    
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if ( self.latitude != [[NSString alloc] initWithFormat:@"%lf",manager.location.coordinate.latitude]) {
        
        self.latitude = [[NSString alloc] initWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
        CGFloat longitude = self.locationManager.location.coordinate.longitude;
        self.longitude = [[NSString alloc] initWithFormat:@"%lf",longitude];
        
        NSLog(@"latitude = %@",self.latitude);
        NSLog(@"longitude = %@",self.longitude);
        NSLog(@"locations = %@",locations);
        
        CLLocation *currentLocation = [locations objectAtIndex:0];
        [manager stopUpdatingLocation];
        
        NSLog(@"currentLocation = %@",currentLocation);
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
           
            CLPlacemark *placemark = placemarks[0];
            NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
            NSString *addressString = [lines componentsJoinedByString:@"\n"];
            NSLog(@"Address: %@", addressString);
            
        }];
        
        [self customViewReload];
    }
    
}

- (void)refershControlAction{
    
    for (UIView *subview in [self.scrollView subviews]) {
        
        if ( [subview class] == [MainView class] ) {
            [subview removeFromSuperview];
            
        } else if ( [subview class] == [LineChart class] ) {
            [subview removeFromSuperview];
            
        } else if ( [subview class] == [WeekForecast class] ) {
            [subview removeFromSuperview];
            
        }
    }
    
    [self.refreshControl endRefreshing];
    [self customViewReload];
}


@end
