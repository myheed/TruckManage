//
//  TruckOnMapVC.m
//  HCBSYSTEM
//
//  Created by itte on 16/4/21.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "TruckOnMapVC.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"

@interface TruckOnMapVC ()<BMKMapViewDelegate>
@property (strong, nonatomic) BMKMapView *bmkMapView;
@property (strong, nonatomic) CustomAnnotationView *customAnnotationView;

@end

@implementation TruckOnMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL bSubViewController = NO;
    bSubViewController = [self.params[@"subVC"] boolValue];
    if (bSubViewController) {
        self.navigationItem.title = @"我的车库";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
        [self addTruckData:self.params[@"dataArray"]];
    }
    [self.view addSubview:self.bmkMapView];
    [self.bmkMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)addTruckData:(NSArray *)dataArray
{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:dataArray];
    [self addAllAnnotation];
}

#pragma mark - lazzy load
- (BMKMapView *)bmkMapView
{
    if (_bmkMapView == nil) {
        _bmkMapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
        _bmkMapView.delegate = self;
        _bmkMapView.mapType = BMKMapTypeStandard;
    }
    return _bmkMapView;
}
-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - mapView相关方法
- (CustomAnnotationView *)customAnnotationView
{
    if (_customAnnotationView == nil) {
        _customAnnotationView = [[CustomAnnotationView alloc] init];
    }
    return _customAnnotationView;
}
// 添加大头针
- (void)addAllAnnotation
{
    [self.bmkMapView removeAnnotations:self.bmkMapView.annotations];
    
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(0, 0);
    for (VechicleInfoModel *vechicleInfo in self.dataArray) {
        CustomAnnotation *customAnnotation = [[CustomAnnotation alloc] init];
        customAnnotation.vechicleInfo = vechicleInfo;
        coor = CLLocationCoordinate2DMake(vechicleInfo.Latitude, vechicleInfo.Longitude);
        customAnnotation.coordinate = coor;
        [self.bmkMapView addAnnotation:customAnnotation];
    }
    if (self.dataArray.count > 12) {
        [self.bmkMapView setZoomLevel:7];
    }
    else
    {
        [self.bmkMapView setZoomLevel:15];
    }
    [self.bmkMapView setCenterCoordinate:coor animated:YES];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation *customAnnotation = (CustomAnnotation *)annotation;
        BMKPinAnnotationView *pinView = [[BMKPinAnnotationView alloc] initWithAnnotation:customAnnotation reuseIdentifier:@"customAnnotation"];
        
        CustomAnnotationView *paopaoView = [[CustomAnnotationView alloc] init];
        paopaoView.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 190);
        paopaoView.layer.cornerRadius = 5;
        paopaoView.backGroundView.backgroundColor = RGB(56, 56, 56);
        
        // 更新相关信息
        WeakSelfType blockSelf = self;
        VechicleInfoModel *truckInfo = customAnnotation.vechicleInfo;
        paopaoView.lbCarNum.text = truckInfo.License;
        paopaoView.lbTime.text = truckInfo.GpsTime;
        paopaoView.lbCurMonthMileage.text = [NSString stringWithFormat:@"当月里程：%@km", truckInfo.TotalDistance];;
        paopaoView.lbSpeed.text = [NSString stringWithFormat:@"速度：%@km/h", truckInfo.Speed];
        int day = [truckInfo.StopTime intValue]/1440;
        int hour = [truckInfo.StopTime intValue]%1440/60;
        int min = [truckInfo.StopTime intValue]%1440%60;
        paopaoView.lbStopTime.text = [NSString stringWithFormat:@"停车时长：%d天%d小时%d分钟",day,hour,min];
        paopaoView.lbStatus.text = [NSString stringWithFormat:@"状态：%@", truckInfo.Status];
        paopaoView.lbAddress.text = truckInfo.Location;
        
        [paopaoView.btnCarInfo bk_whenTapped:^{
            [blockSelf pushViewController:@"TruckInfoVC" withParams:@{@"TruckInfo":truckInfo}];
        }];
        NSString *VID = customAnnotation.vechicleInfo.VID;
        [paopaoView.btnTracePlay bk_whenTapped:^{
            [blockSelf pushViewController:@"TracePlayVController" withParams:@{@"vehicleID":VID}];
        }];
        pinView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView];
        
        int direct = [customAnnotation.vechicleInfo.Direction intValue];
        UIImage *image;
        if(direct == 0 || direct == 360){
            image = [UIImage imageNamed:@"icon_north"];
        }else if (direct == 90) {
            image = [UIImage imageNamed:@"icon_east"];
        }else if (direct > 0 && direct < 90) {
            image = [UIImage imageNamed:@"icon_eastNorth"];
        }else if (direct > 90 && direct < 180) {
            image = [UIImage imageNamed:@"icon_eastSouth"];
        }else if (direct == 180) {
            image = [UIImage imageNamed:@"icon_sorth"];
        }else if (direct > 180 && direct < 270) {
            image = [UIImage imageNamed:@"icon_westSouth"];
        }else if (direct == 270) {
            image = [UIImage imageNamed:@"icon_west"];
        }else{
            image = [UIImage imageNamed:@"icon_westNorth"];
        }
        [pinView setImage:image];
        [pinView setAnimatesDrop:NO];
        pinView.canShowCallout = YES;
        
        CGFloat posX = pinView.centerX - 20;
        CGFloat posY = pinView.height + 2;
        UILabel *vehicle = [[UILabel alloc]initWithFrame:CGRectMake(posX, posY, 70, 20)];
        vehicle.textColor = [UIColor redColor];
        vehicle.backgroundColor = [UIColor whiteColor];
        [vehicle setTextAlignment:NSTextAlignmentCenter];
        vehicle.text = customAnnotation.vechicleInfo.License;
        vehicle.font = [UIFont systemFontOfSize:12.0];
        vehicle.layer.borderWidth = 1.0;
        vehicle.layer.borderColor = [UIColor redColor].CGColor;
        vehicle.layer.cornerRadius = 4;
        [pinView addSubview:vehicle];
        return pinView;
    }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation *customAnn = (CustomAnnotation *)view.annotation;
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(customAnn.vechicleInfo.Latitude, customAnn.vechicleInfo.Longitude);
        [self.bmkMapView setCenterCoordinate:coor animated:YES];
    }
}
@end
