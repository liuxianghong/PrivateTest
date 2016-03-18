//
//  ViewController.m
//  testBle
//
//  Created by 刘向宏 on 16/3/16.
//  Copyright © 2016年 刘向宏. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"

#import "BluetoothManager.h"
#import <WeatherUI/WUIAsynchronousAssetLoader.h>
#import <Weather/City.h>
#import <CoreLocation/CoreLocation.h>
#import <WeatherUI/WUIDynamicWeatherBackground.h>
#import <WeatherUI/WUIWeatherConditionBackgroundView.h>
#import <Weather/TWCCityUpdater.h>
#import "NSObject+methods.h"



@interface ViewController ()<CLLocationManagerDelegate>
@end

@implementation ViewController{
    CLLocationManager *_locationManager;
    TWCCityUpdater *cu;
    BluetoothManager *manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    manager = [BluetoothManager sharedInstance];
    [manager logMethods];
    [self performSelector:@selector(bleIformation) withObject:nil afterDelay:1.0f] ;
    WUIAsynchronousAssetLoader *loader = [WUIAsynchronousAssetLoader sharedAssetLoader];
    City *city = [[City alloc] init];
    CLLocation *l = [[CLLocation alloc] initWithLatitude:10 longitude:10];
    [city setLocation:l];
    [loader loadCADataForCity:city];
    
    
    cu = [TWCCityUpdater sharedCityUpdater];

    [cu setRequestedCities:@[city]];
    [cu updateWeatherForCities:@[city] withCompletionHandler:^(id anyobject){
        //NSLog(@"Completion :%@",anyobject);
    }];
    
    
    NSBundle *bb = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/FTServices.framework"];
    if ([bb load]) {
        Class FTDeviceSupport = NSClassFromString(@"FTDeviceSupport");
        id si = [FTDeviceSupport valueForKey:@"sharedInstance"];
        NSLog(@"%@",si);
        NSLog(@"-- %@", [si valueForKey:@"deviceInformationString"]);
        NSLog(@"-- %@", [si valueForKey:@"model"]);
        NSLog(@"-- %@", [si valueForKey:@"deviceName"]);
        NSLog(@"-- %@", [si valueForKey:@"deviceColor"]);
        NSLog(@"-- %@", [si valueForKey:@"productName"]);
        NSLog(@"-- %@", [si valueForKey:@"productVersion"]);
        NSLog(@"-- %@", [si valueForKey:@"userAgentString"]);
        NSLog(@"-- %@", [si valueForKey:@"CTNetworkInformation"]);
        NSLog(@"-- %@", [si valueForKey:@"deviceTypeIDPrefix"]);
    }
    
    
    
    
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bleClick:(id)sender
{
    BOOL currentState = [manager enabled] ;
    [manager setEnabled:!currentState];
    [manager setPowered:!currentState];
    NSLog(@"%@",[manager pairedDevices]);
    NSLog(@"%@",[manager connectedDevices]);
    NSLog(@"%@",[manager connectingDevices]);
    NSLog(@"%d",[BluetoothManager lastInitError]);
    
}

-(void)bleIformation{
    NSLog(@"%@",[manager localAddress]);
}

#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
    
    City *city = [[City alloc] init];
    [city setLocation:location];
    [city update];
    NSLog(@"%@",[city updateTimeString]);
    [cu setRequestedCities:@[city]];
    [cu updateWeatherForCities:@[city] withCompletionHandler:^(id anyobject,id anyobject2,id anyobject3){
        NSLog(@"Completion :%@",anyobject);
        NSLog(@"windSpeed:%f,windChill:%f",city.windSpeed,city.windChill);
        NSLog(@"%@",city.temperature);
        NSLog(@"%d",city.sunriseTime);
        NSLog(@"%d",city.sunsetTime);
        NSLog(@"%@",city.state);
        
        WUIWeatherConditionBackgroundView *bg = [[WUIWeatherConditionBackgroundView alloc] init];
        bg.frame = self.view.bounds;
        [bg setCities:@[city]];
        NSLog(@"%@",bg);
        bg.backgroundColor = [UIColor redColor];
        [bg _addBackAllLayers];
        [bg updateConditionsAboutCityIndex:0];
        WUIWeatherCondition *con = [bg _conditionAtIndex:0];
        [con setPlaying:YES];
        NSLog(@"%@  %d",con,[con playing]);
        [self.view addSubview:bg];
        [self.view sendSubviewToBack:bg];
    }];
    NSLog(@"%@",[cu requestedCities]);
    
}

@end
