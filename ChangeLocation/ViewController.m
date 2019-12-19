//
//  ViewController.m
//  ChangeLocation
//
//  Created by butter on 2019/12/19.
//  Copyright © 2019 butter. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationController.h"

@import KissXML;
@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong)CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Location" ofType:@"gpx"];
//    NSError *error;
//    NSString *gpxStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
//
//    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:gpxStr options:kNilOptions error:&error];
//    DDXMLElement *node = (DDXMLElement *)doc.rootElement.nextNode;
//
//    NSMutableArray <DDXMLNode *>*array = [NSMutableArray arrayWithArray:node.attributes];
//
//    DDXMLNode *latNode = array.firstObject;
//    DDXMLNode *lonNode = array.lastObject;
//    latNode.stringValue = @"23.132175";
//    lonNode.stringValue = @"113.32703";
//
//    NSString *result =  [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"123.gpx"];
//    [[doc XMLString] writeToFile:result atomically:YES encoding:NSUTF8StringEncoding error:&error];
    

    /*
     CLLocation *loca = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
     CLLocationCoordinate2D c2d = [LocationController gcj02ToWgs84:loca.coordinate];
     NSLog(@"纬度------%f\n------精度%f", lat, lon);
     */
  
    //http://lbs.amap.com/console/show/picker   //23.132175   113.32703   广东省-广州市-天河区-天河北街172号
    
    NSString *searchStr = @"河南驻马店火车站";
    [self getLoc:searchStr success:^(CGFloat lat, CGFloat lon) {
         NSLog(@"纬度------%f\n------精度%f", lat, lon);
        [self startLocation];
    } fail:^(NSError *error) {

    }];

}

//逆编码获取位置坐标
- (void)getLoc:(NSString *)address  success:(void (^)(CGFloat lat, CGFloat lon))coordinate fail:(void(^)(NSError *error))fail {
    //使用地理位置 逆向编码拿到位置信息
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    //逆编码当前位置
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark * placeMark = placemarks[0];
            coordinate(placeMark.location.coordinate.latitude,placeMark.location.coordinate.longitude);
        }else {
            fail(error);
        }}];
}

- (void)startLocation {
    _locationManager =[[CLLocationManager alloc]init];
    _locationManager.delegate =self;
       //设置定位经准
    _locationManager.desiredAccuracy =kCLLocationAccuracyNearestTenMeters;
    [_locationManager requestWhenInUseAuthorization];//否则，ios10不弹定位框
    _locationManager.distanceFilter =10.0f;
    //开始定位
    [_locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (locations.count) {
        CLLocation *newLocation = locations.firstObject;
        [_locationManager stopUpdatingLocation];
        CLGeocoder *geoCoder =[[CLGeocoder alloc]init];
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count) {
                CLPlacemark *place = placemarks.firstObject;
                NSLog(@"%@-%@-%@-%@", place.administrativeArea, place.locality, place.subLocality, place.name);
            }
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code] == kCLErrorDenied){
        NSLog(@"访问被拒绝");
        
    }
    
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
        
    }
    
}


@end
