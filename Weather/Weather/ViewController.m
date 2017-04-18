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

#import "LineChart.h"
#import "MainView.h"
#import "DustView.h"

#import "DWWeatherManager.h"
#import "DWDustManager.h"

#import "WeekForecast.h"
#import "AreaCoordinate.h"


@interface ViewController () <UIScrollViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) UIButton *weatherDustButton;

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
    
    self.weatherDustButton = [[UIButton alloc] init];
    self.weatherDustButton.titleLabel.text = @"먼지";
    self.weatherDustButton.titleLabel.textColor = [UIColor blueColor];
    
    self.weatherDustButton.frame = CGRectMake(self.view.frame.size.width/2 + self.view.frame.size.width/4, 50, 50, 30);
    
    [self.weatherDustButton addTarget:self action:@selector(weatherDustButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.weatherDustButton];
    
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
#pragma mark scrollDelegate alpha
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if ( scrollView.contentOffset. y < 400 ) {
        
        CGFloat alpha = 0;
        alpha = scrollView.contentOffset.y / 600;
        self.alphaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
        
    }
}

#pragma mark dustNetwork
- (void)dustNetworkReload {
    
    __block ViewController *wself = self;
    
    [DWDustManager requestWGS84ToTM:self.latitude longitude:self.longitude updateDataBlock:^{
        
        NSDictionary *TMData = [DataSingleTon sharedDataSingleTon].TMData;
        
        [DWDustManager requestMeasureStationData:TMData[@"x"] yCoordinate:TMData[@"y"] updateDataBlock:^{
            
            NSDictionary *measureStaion = [DataSingleTon sharedDataSingleTon].mesureStation;
            NSArray *measureStationArray = measureStaion[@"list"];
            NSDictionary *measureDictionary = measureStationArray[0];
            NSString *measureStationString = measureDictionary[@"stationName"];
            
            
            [DWDustManager requestDustData:measureStationString updateDataBlock:^{
                [wself dustViewReload];
            }];
            
        }];
        
    }];
    
}

#pragma mark weatherNetwrok
- (void)weatherNetworkReload {
    
    //NSDictionary *data = @{@"lon":self.longitude,@"village":@"",@"country":@"",@"foretxt":@"",@"lat":self.latitude,@"city":@""};
    
    __block ViewController *wself = self;
    
    [DWWeatherManager requestCurrentDataLongitude:self.longitude village:nil country:nil foretxt:nil latitude:self.latitude city:nil updateDataBlock:^{
        
        [DWWeatherManager requestTwoDayForecastDataLongitude:self.longitude village:nil country:nil foretxt:nil latitude:self.latitude city:nil updateDataBlock:^{
            
            [DWWeatherManager requestWeekForecastDataLongitude:self.longitude village:nil country:nil foretxt:nil latitude:self.latitude city:nil updateDataBlock:^{
                
                [wself mainViewReload];
                [wself lineChartViewReload];
                [wself weekDataReload];
                
            }];
            
        }];
        
    }];
}

#pragma mark weatherView
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
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [mainView addGestureRecognizer:singleFingerTap];
    
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

#pragma mark dustView
- (void)dustViewReload {
    
    DustView *dustView = [[DustView alloc] init];
    
    dustView.frame = CGRectMake(0, self.view.frame.size.height/2, self.scrollView.frame.size.width, self.scrollView.frame.size.height/3 *2);
    
    NSDictionary *dustDictionary = [DataSingleTon sharedDataSingleTon].dustData;
    NSArray *dustTimeArray = dustDictionary[@"list"];
    NSDictionary *dustFirstData = dustTimeArray[0];
    dustView.dustDataDictionary = dustFirstData;
    
    [dustView setNeedsDisplay];
    [self.scrollView addSubview:dustView];
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

#pragma mark current location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if ( self.latitude != [[NSString alloc] initWithFormat:@"%lf",manager.location.coordinate.latitude]) {
        
        self.latitude = [[NSString alloc] initWithFormat:@"%lf",self.locationManager.location.coordinate.latitude];
        CGFloat longitude = self.locationManager.location.coordinate.longitude;
        self.longitude = [[NSString alloc] initWithFormat:@"%lf",longitude];
        
        NSLog(@"latitude = %@",self.latitude);
        NSLog(@"longitude = %@",self.longitude);\
        
        CLLocation *currentLocation = [locations objectAtIndex:0];
        [manager stopUpdatingLocation];
        
        NSLog(@"currentLocation = %@",currentLocation);
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        
        AreaCoordinate *coordinate = [[AreaCoordinate alloc] init];
        NSDictionary *naver = [coordinate areaCoordinate:self.latitude longitude:self.longitude];
        
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
           
            CLPlacemark *placemark = placemarks[0];
            NSLog(@"Address locality: %@",placemark.locality);
            NSLog(@"Address administrativeArea: %@",placemark.administrativeArea);
            
            [self weatherNetworkReload];
            
        }];
        
    }
    
}

#pragma mark TapGesture 
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    
    
    터치도 되고 화면도 움직이는데 위로는 올라가는데 아래로는 내려오지 않음.
    
    if ( self.scrollView.contentOffset.y > self.view.frame.size.height ) {
        
        self.scrollView.contentOffset = CGPointMake(0, self.view.frame.size.height - self.view.frame.size.height/3);
        
        NSLog(@"hello1");
        
    } else {
        
        self.scrollView.contentOffset = CGPointMake(0, 0);
        
        
        NSLog(@"hello2");
    }
}


#pragma mark refreshControl
- (void)refershControlAction{
    
    if ( [self.weatherDustButton.titleLabel.text isEqualToString:@"먼지"] ) {
        
        for (UIView *subview in [self.scrollView subviews]) {
            
            if ( [subview class] == [MainView class] ) {
                [subview removeFromSuperview];
                
            } else if ( [subview class] == [LineChart class] ) {
                [subview removeFromSuperview];
                
            } else if ( [subview class] == [WeekForecast class] ) {
                [subview removeFromSuperview];
                
            } else if ( [subview class] == [DustView class] ) {
                [subview removeFromSuperview];
            }
        }
        
        [self.refreshControl endRefreshing];
        [self weatherNetworkReload];
        
    } else {
        
        for (UIView *subview in [self.scrollView subviews]) {
            
            if ( [subview class] == [MainView class] ) {
                [subview removeFromSuperview];
                
            } else if ( [subview class] == [LineChart class] ) {
                [subview removeFromSuperview];
                
            } else if ( [subview class] == [WeekForecast class] ) {
                [subview removeFromSuperview];
                
            } else if ( [subview class] == [DustView class] ) {
                [subview removeFromSuperview];
            }
        }
        
        [self.refreshControl endRefreshing];
        [self dustNetworkReload];
        
    }
    
}

#pragma weatehrDustButton
- (void)weatherDustButton:(UIButton *)sender {
    
    if ( [self.weatherDustButton.titleLabel.text isEqualToString:@"먼지"] ) {
        
        for (UIView *subview in [self.scrollView subviews]) {
            
            if ( [subview class] == [MainView class] ) {
                [subview removeFromSuperview];
                
            } else if ( [subview class] == [LineChart class] ) {
                [subview removeFromSuperview];
                
            } else if ( [subview class] == [WeekForecast class] ) {
                [subview removeFromSuperview];
                
            } else if ( [subview class] == [DustView class] ) {
                [subview removeFromSuperview];
            }
        }
    
        self.weatherDustButton.titleLabel.text = @"날씨";
        [self dustNetworkReload];
        
    } else {
        
        for (UIView *subview in [self.scrollView subviews]) {
            
            if ( [subview class] == [MainView class] ) {
                [subview removeFromSuperview];
                
            } else if ( [subview class] == [LineChart class] ) {
                [subview removeFromSuperview];
                
            } else if ( [subview class] == [WeekForecast class] ) {
                [subview removeFromSuperview];
                
            } else if ( [subview class] == [DustView class] ) {
                [subview removeFromSuperview];
            }
        }
        
        self.weatherDustButton.titleLabel.text = @"먼지";
        [self weatherNetworkReload];
        
    }
    
    
}


@end
