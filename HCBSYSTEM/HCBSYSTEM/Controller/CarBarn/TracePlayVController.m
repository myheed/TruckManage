//
//  TracePlayVController.m
//  HCBSYSTEM
//
//  Created by itte on 16/4/6.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "TracePlayVController.h"
#import "JLSlider.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface TracePlayVController ()<BMKMapViewDelegate>
{
    NSString *VID;           // 车牌号码
    BOOL bShowPrepareView;   // 是否显示准备播放view
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (assign, nonatomic)  BOOL bIsStartTimeChoice;  // 是否是开始时间选择
@property (copy, nonatomic) NSString *startTime;     // 播放开始时间
@property (copy, nonatomic) NSString *endTime;       // 播放结束时间
// 播放进度相关View
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet JLSlider *playerSlider;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UILabel *lbCurTime;
@property (weak, nonatomic) IBOutlet UILabel *lbCurSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lbCurDirection;
@property (weak, nonatomic) IBOutlet UILabel *lbCurAddress;

// 播放准备相关View
@property (weak, nonatomic) IBOutlet UIView *prepareView;
@property (weak, nonatomic) IBOutlet UILabel *lbStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lbEndTime;
@property (weak, nonatomic) IBOutlet UIButton *btnYestoday;
@property (weak, nonatomic) IBOutlet UIButton *btnBeforeYestoday;

// 弹起收回按钮
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIImageView *imgUnfold;
// 时间选择View
@property (strong, nonatomic) IBOutlet UIView *datePckMaskView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePckView;


@property (strong, nonatomic) BMKMapView *bmkMapView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic,strong) NSTimer *timer;

@property (assign, nonatomic) NSInteger indexOfPoint;
@property (retain, nonatomic) BMKPointAnnotation *dynamicPoint;      //动态车点
@property (retain, nonatomic) BMKPointAnnotation *startPoint;
@property (retain, nonatomic) BMKPointAnnotation *endPoint;
@property (retain, nonatomic) BMKPolyline *polyLine;
@end

@implementation TracePlayVController

- (void)viewDidLoad {
    [super viewDidLoad];
    VID = self.params[@"vehicleID"];
    NSLog(@"vid: %@",VID);
    self.navigationItem.title = @"轨迹回放";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];

    // 车辆轨迹动态点
    self.indexOfPoint = 0;
    self.dynamicPoint = [[BMKPointAnnotation alloc] init];
    self.dynamicPoint.title = @"当前状态";
    
    [self subViewInit];
}

#pragma mark - 播放前的准备
// 初始化显示视图
- (void)subViewInit
{
    bShowPrepareView = YES;
    self.btnPlay.selected = YES;
    [self.contentView addSubview:self.bmkMapView];
    [_bmkMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.bmkMapView setZoomLevel:13];
    
    // 初始化昨天前天显示两个按钮
    self.btnYestoday.layer.borderWidth = 0.5;
    self.btnYestoday.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnYestoday.layer.cornerRadius = 5;
    self.btnBeforeYestoday.layer.borderWidth = 0.5;
    self.btnBeforeYestoday.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnBeforeYestoday.layer.cornerRadius = 5;
    WeakSelfType blockSelf = self;
    // 默认显示当天时间
    NSDate *date = [NSDate date];
    NSString *today = [TimeUtils timeStringFromDate:date withFormat:@"MM-dd"];
    NSString *todayAll = [TimeUtils timeStringFromDate:date withFormat:@"yyy-MM-dd"];
    self.startTime = [todayAll addString:@" 00:00:00"];
    self.endTime = [todayAll addString:@" 23:59:59"];
    self.lbStartTime.text = [today addString:@" 00:00"];
    self.lbEndTime.text = [today addString:@" 23:59"];
    // 时间选择
    [self.lbStartTime bk_whenTapped:^{
        blockSelf.bIsStartTimeChoice = YES;
        [blockSelf showDatePickerView];
    }];
    [self.lbEndTime bk_whenTapped:^{
        blockSelf.bIsStartTimeChoice = NO;
        [blockSelf showDatePickerView];
    }];
    // 设置播放进度条
    self.playerSlider.value = 0.0;
    [self.playerSlider setThumbImage:[UIImage imageNamed:@"process_truck"] forState:UIControlStateNormal];
    [self.playerSlider setMaximumTrackImage:[UIImage imageNamed:@"play_progressBG"] forState:UIControlStateNormal];
    [self.playerSlider setMinimumTrackImage:[UIImage imageNamed:@"play_progress"] forState:UIControlStateNormal];
    // 初始化并添加两个view
    self.playerView.frame = CGRectMake(0, SCREEN_HEIGHT-110-35, SCREEN_WIDTH, 110);
    self.playerView.backgroundColor = [RGB(60, 60, 60) colorWithAlphaComponent:0.8];
    [self.view addSubview:self.playerView];
    self.prepareView.frame = CGRectMake(0, SCREEN_HEIGHT-110-35, SCREEN_WIDTH, 110);
    self.prepareView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.prepareView];
    
    [self.popView bk_whenTapped:^{
        [blockSelf operatePrepareView];
    }];
    self.popView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.popView.layer.borderWidth = 1.0;
    self.datePckMaskView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    [self.view addSubview:self.datePckMaskView];
    [self.popView bringSubviewToFront:self.view];
    [self.datePckMaskView bringSubviewToFront:self.view];
}
// 时间快捷选择
- (IBAction)timeChoiceClick:(UIButton *)sender
{
    NSInteger interval = 0;
    // 昨天按钮选择
    if (sender.tag == 500) {
        interval = -1;
    }
    // 前天按钮选择
    else if (sender.tag == 600){
        interval = -2;
    }
    // 当天按钮选择
    else{
        interval = 0;
    }
    NSDate *day = [TimeUtils IntervalOfCurrentDate:interval];
    NSString *dayStr = [TimeUtils timeStringFromDate:day withFormat:@"MM-dd"];
    NSString *dayStrAll = [TimeUtils timeStringFromDate:day withFormat:@"yyy-MM-dd"];
    self.startTime = [dayStrAll addString:@" 00:00:00"];
    self.endTime = [dayStrAll addString:@" 23:59:59"];
    self.lbStartTime.text = [dayStr addString:@" 00:00"];
    self.lbEndTime.text = [dayStr addString:@" 23:59"];
}

- (void)operatePrepareView
{
    bShowPrepareView = !bShowPrepareView;
    if (bShowPrepareView)
    {
        [self showPrepareView];
    }
    else
    {
        [self hidePrepareView];
    }
    
}
// 隐藏准备播放view
- (void)hidePrepareView
{
    self.prepareView.top = SCREEN_HEIGHT-110-35;
    [UIView animateWithDuration:0.3 animations:^{
        self.imgUnfold.transform = CGAffineTransformMakeRotation(M_PI);
        self.prepareView.top = SCREEN_HEIGHT;
    }];
    
}
// 显示准备播放view
- (void)showPrepareView
{
    self.prepareView.top = SCREEN_HEIGHT;
    
    self.btnPlay.selected = NO;
    [self playHistoryTrace:self.btnPlay];
    [UIView animateWithDuration:0.3 animations:^{
        self.imgUnfold.transform = CGAffineTransformMakeRotation(0);
        self.prepareView.top = SCREEN_HEIGHT-110-35;
    }];
    
}
// 开始准备播放
- (IBAction)btnPreparePlayClick
{
    [self loadNetworkData];
    [self operatePrepareView];
}

#pragma mark - lazy load
- (BMKMapView *)bmkMapView
{
    if (_bmkMapView == nil) {
        _bmkMapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
        _bmkMapView.mapType = BMKMapTypeStandard;
        _bmkMapView.delegate = self;
    }
    return _bmkMapView;
}
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
#pragma mark - DatePickerView 操作
-(void)showDatePickerView
{
    self.datePckMaskView.top = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.datePckMaskView.bottom = SCREEN_HEIGHT;
    }];
}
-(void)hideDatePickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.datePckMaskView.top = SCREEN_HEIGHT;
    }];
}
- (IBAction)btnCancelClick
{
    [self hideDatePickerView];
}
- (IBAction)btnOKClick
{
    NSDate *date = self.datePckView.date;
    NSString *dayStr = [TimeUtils timeStringFromDate:date withFormat:@"MM-dd HH:mm"];
    NSString *dayStrAll = [TimeUtils timeStringFromDate:date withFormat:@"yyy-MM-dd HH:mm:ss"];
    if (self.bIsStartTimeChoice) {
        self.lbStartTime.text = dayStr;
        self.startTime = dayStrAll;
    }
    else{
        self.lbEndTime.text = dayStr;
        self.endTime = dayStrAll;
    }
    [self hideDatePickerView];
}

#pragma mark - 获取网络数据
- (void)loadNetworkData
{
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:VID forKey:@"vehicleID"];
    [dictParam setObject:self.startTime forKey:@"startTime"];
    [dictParam setObject:self.endTime forKey:@"endTime"];
    [self showHUDLoading];
    [[AFNetworkManager sharedInstance] AFNHttpRequestWithAPI:KGetPlayBack andDictParam:dictParam requestSuccessed:^(id responseObject) {
        [self hideHUDLoading];
        CommonModel *commModel = [CommonModel mj_objectWithKeyValues:responseObject];
        if (![commModel.Status.trimString isEqualToString:@"OK"]) {
            return ;
        }
        NSArray *data = [CarTraceModel mj_objectArrayWithKeyValuesArray:commModel.Content];
        if (data.count > 0) {
            [self.dataArray addObjectsFromArray:data];
            [self drawHistoryTrace];
            self.playerSlider.value = 0.0;
            [self playHistoryTrace:self.btnPlay];
        }
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self hideHUDLoading];
    }];
}

#pragma mark - 进行信息处理
// 在地图上画车辆轨迹
- (void)drawHistoryTrace
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.dataArray.count < 2) {
            return ;
        }
        CLLocationCoordinate2D bmkPoints[self.dataArray.count];
        
        for (int i=0; i<self.dataArray.count; i++) {
            CLLocationCoordinate2D coord;
            CarTraceModel *tracePoint = self.dataArray[i];
            if (i == 0) {
                self.startPoint = [[BMKPointAnnotation alloc] init];
                self.startPoint.coordinate = CLLocationCoordinate2DMake(tracePoint.Latitude, tracePoint.Longitude);
                self.startPoint.title = @"起点";
                self.startPoint.subtitle = @"车辆轨迹起点";
                [self.bmkMapView addAnnotation:self.startPoint];
            }
            else if (i == (self.dataArray.count-1)){
                self.endPoint = [[BMKPointAnnotation alloc] init];
                self.endPoint.coordinate = CLLocationCoordinate2DMake(tracePoint.Latitude, tracePoint.Longitude);
                self.endPoint.title = @"终点";
                self.endPoint.subtitle = @"车辆轨迹终点";
                [self.bmkMapView addAnnotation:self.endPoint];
            }
            coord.latitude = tracePoint.Latitude;
            coord.longitude = tracePoint.Longitude;
            
            bmkPoints[i] = coord;
        }
        if (self.dataArray.count < 500) {
            [self.bmkMapView setZoomLevel:13];
        }
        else{
            [self.bmkMapView setZoomLevel:12];
        }
        self.polyLine = [BMKPolyline polylineWithCoordinates:bmkPoints count:self.dataArray.count];
        [self.bmkMapView addOverlay:self.polyLine];
        [self.bmkMapView setCenterCoordinate:bmkPoints[0] animated:YES];
    });
}
// 播放历史轨迹
- (IBAction)playHistoryTrace:(UIButton *)sender
{
    if(self.dataArray.count == 0){
        return ;
    }
    if (sender.selected) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(playAnnimation) userInfo:nil repeats:YES];
        [sender setImage:[UIImage imageNamed:@"play_pause"] forState:UIControlStateNormal];
        [self.timer fire];
        if (self.playerSlider.value == 0.0) {
            sender.selected = YES;
        }
        else{
            sender.selected = NO;
        }
    }
    else{
        sender.selected = YES;
        [self.timer invalidate];
        self.timer = nil;
        [sender setImage:[UIImage imageNamed:@"play_begin"] forState:UIControlStateNormal];
    }
}
// 播放时进行的动画处理
- (void)playAnnimation
{
    float interval = 1.0/self.dataArray.count;
    self.playerSlider.value += interval;
    if (self.playerSlider.value + 0.01 > 1.0) {
        [self.timer invalidate];
        self.timer = nil;
        [self showSuccessResult:@"播放完毕"];
        self.btnPlay.selected = YES;
        self.playerSlider.value = 0.0;
        self.indexOfPoint = 0;
        [self.bmkMapView removeAnnotation:self.dynamicPoint];
        [self.btnPlay setImage:[UIImage imageNamed:@"play_begin"] forState:UIControlStateNormal];
    }
    if (self.indexOfPoint < self.dataArray.count) {
        CarTraceModel *carPos = self.dataArray[self.indexOfPoint];
        self.dynamicPoint.coordinate = CLLocationCoordinate2DMake(carPos.Latitude, carPos.Longitude);
        self.dynamicPoint.subtitle = carPos.Status;
        [self.bmkMapView addAnnotation:self.dynamicPoint];
        self.indexOfPoint++;
        NSInteger direct = carPos.Direction;
        NSString *carDirection = @"";
        if(direct == 0 || direct == 360){
            carDirection = @"北方";
        }else if (direct == 90) {
            carDirection = @"东方";
        }else if (direct > 0 && direct < 90) {
            carDirection = @"东北";
        }else if (direct > 90 && direct < 180) {
            carDirection = @"东南";
        }else if (direct == 180) {
            carDirection = @"南方";
        }else if (direct > 180 && direct < 270) {
            carDirection = @"西南";
        }else if (direct == 270) {
            carDirection = @"西方";
        }else{
            carDirection = @"南北";
        }
        self.lbCurTime.text = carPos.Gpstime;
        self.lbCurSpeed.text = [NSString stringWithFormat:@"%ldkm/h",(long)carPos.Speed];
        self.lbCurDirection.text = carDirection;
        self.lbCurAddress.text = carPos.Locations;
        
        // 设置居中
        [self.bmkMapView setCenterCoordinate:self.dynamicPoint.coordinate animated:YES];
    }
    else{
        [self.timer invalidate];
        self.timer = nil;
        [self.bmkMapView removeAnnotation:self.dynamicPoint];
    }
}

// 滑块处理
- (void)changeSliderValue
{
    
}

#pragma mark - mapViewDelegate
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView *lineview = [[BMKPolylineView alloc] initWithOverlay:overlay];
        lineview.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.8];
        lineview.lineWidth = 2.0;
        return lineview;
    }
    return nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKPinAnnotationView * annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    annotationView.pinColor = BMKPinAnnotationColorPurple;
    annotationView.animatesDrop = YES;
    annotationView.annotation = annotation;
    
    BMKPointAnnotation *pointAnnotation = (BMKPointAnnotation *)annotation;
    if ([pointAnnotation.title isEqualToString:@"起点"]) {
        annotationView.image = [UIImage imageNamed:@"icon_startPos"];
    }
    else if ([pointAnnotation.title isEqualToString:@"终点"]) {
        annotationView.image = [UIImage imageNamed:@"icon_endPos"];
    }
    else if ([pointAnnotation.title isEqualToString:@"当前状态"]) {
        annotationView.image = [UIImage imageNamed:@"icon_onWay"];
    }
    [annotationView setAnimatesDrop:NO];
    return annotationView;
}
@end
