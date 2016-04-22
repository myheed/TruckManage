//
//  CarBarnVController.m
//  HCBSYSTEM
//
//  Created by itte on 16/4/6.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "CarBarnVController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import "TruckInfoTableCell.h"
#import "UserLoginVController.h"
#import <MJRefresh.h>
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"
#import "TruckOnMapVC.h"

@interface CarBarnVController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    BOOL bListViewType;
    NSInteger pageSize;
    NSInteger pageIndex;
    NSString *searKey;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TruckOnMapVC *truckMap;
@property (strong, atomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UITextField *txtSearch;
@end

@implementation CarBarnVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.txtSearch;
    [self.contentView addSubview:self.truckMap.view];
    [self.contentView addSubview:self.tableView];
    [self addChildViewController:self.truckMap];
    
    bListViewType = YES;
    pageIndex = 1;
    pageSize = 20;
    searKey = @"";
    
    [self.truckMap.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _dataArray = [NSMutableArray array];
    
    // 切换视图
    [self changeViewType];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardExit)];
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];
    [self.truckMap.view addGestureRecognizer:tapGesture];
    
    addNObserver(@selector(loadNetworkData), kNotificationLoginSuccess);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    removeNObserver(kNotificationLoginSuccess);
}

#pragma mark - 键盘操作
- (void)keyboardExit
{
    [self.txtSearch resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self keyboardExit];
    searKey = textField.text.trimString;
    pageIndex = 1;
    pageSize = (bListViewType)?20:100;
    [self.dataArray removeAllObjects];
    [self loadNetworkData];
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    searKey = textField.text.trimString;
    pageIndex = 1;
    pageSize = (bListViewType)?20:100;
    [self.dataArray removeAllObjects];
    [self loadNetworkData];
}

#pragma mark - lazy load
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 175;
        WeakSelfType weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            pageIndex = 1;
            [weakSelf loadNetworkData];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadNetworkData];
        }];
        [_tableView registerNib:[UINib nibWithNibName:@"TruckInfoTableCell" bundle:nil] forCellReuseIdentifier:@"TruckInfoTableCellID"];
    }
    return _tableView;
}

- (TruckOnMapVC *)truckMap
{
    if (_truckMap == nil) {
        _truckMap = [[TruckOnMapVC alloc] init];
        _truckMap.view.frame = self.contentView.bounds;
    }
    return _truckMap;
}

-(UITextField *)txtSearch
{
    if (_txtSearch == nil) {
        _txtSearch = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 30)];
        _txtSearch.backgroundColor = [UIColor whiteColor];
        _txtSearch.layer.cornerRadius = 15;
        _txtSearch.returnKeyType = UIReturnKeySearch;
        _txtSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtSearch.delegate = self;
        [_txtSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _txtSearch.placeholder = @"车牌号码";
    }
    return _txtSearch;
}

// 切换地图和列表模式
- (void)changeViewType
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    if (bListViewType) {
        [self.navigationController.navigationBar setBarTintColor:KNavigationBarColor];
        [self.tableView setHidden:NO];
        [self.truckMap.view setHidden:YES];
        pageSize = 20;
        pageIndex = 1;
        bListViewType = NO;
        self.txtSearch.backgroundColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_map"] style:UIBarButtonItemStylePlain target:self action:@selector(changeViewType)];
        if (self.dataArray.count == 0) {
            [self.dataArray removeAllObjects];
            [self loadNetworkData];
        }
    }
    else{
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [self.tableView setHidden:YES];
        [self.truckMap.view setHidden:NO];
        pageSize = 100;
        pageIndex = 1;
        bListViewType = YES;
        self.txtSearch.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_list"] style:UIBarButtonItemStylePlain target:self action:@selector(changeViewType)];
        if (self.truckMap.dataArray.count == 0) {
            [self loadNetworkData];
        }
    }
}

#pragma mark - 网络数据处理
- (void) loadNetworkData
{
    if(![Login sharedInstance].isLogined)
    {
        return ;
    }
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setObject:[Login sharedInstance].userID forKey:@"UserID"];
    [dictParam setObject:@(pageSize) forKey:@"pageSize"];
    [dictParam setObject:@(pageIndex) forKey:@"pageIndex"];
    [dictParam setObject:[Login sharedInstance].user.userType forKey:@"userType"];
    [dictParam setObject:@"" forKey:@"status"];
    [dictParam setObject:searKey forKey:@"filter"];

    [self showHUDLoading];
    [[AFNetworkManager sharedInstance] AFNHttpGetWithAPI:KGetGetVehicleInfo andDictParam:dictParam requestSuccessed:^(id responseObject) {
        [self hideHUDLoading];
        CommonModel *commModel = [CommonModel mj_objectWithKeyValues:responseObject];
        if ([commModel.Status.trimString isEqualToString:@"OK"]) {
            NSArray *data = [VechicleInfoModel mj_objectArrayWithKeyValuesArray:commModel.Content];
            
            if (!bListViewType) {
                [self.dataArray addObjectsFromArray:data];
                pageIndex++;
                [self.tableView reloadData];
            }
            else{
                NSLog(@"车辆总数：%lu",(unsigned long)data.count);
                [self.truckMap addTruckData:data];
            }
        }
        else{
            NSLog(@"%@",commModel.ErrorMsg);
        }
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self hideHUDLoading];
    }];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TruckInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TruckInfoTableCellID"];
    if (cell == nil) {
        cell = [[TruckInfoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TruckInfoTableCellID"];
    }
    VechicleInfoModel *vechicleInfo = self.dataArray[indexPath.row];
    cell.lbCarNum.text = vechicleInfo.License;
    cell.lbTime.text = vechicleInfo.GpsTime;
    cell.lbCurMonthKM.text = [NSString stringWithFormat:@"当月里程：%@km", vechicleInfo.TotalDistance];
    cell.lbSpeed.text = [NSString stringWithFormat:@"速度：%@km/h", vechicleInfo.Speed];
    cell.lbStatus.text = [NSString stringWithFormat:@"状态：%@", vechicleInfo.Status];
    int day = [vechicleInfo.StopTime intValue]/1440;
    int hour = [vechicleInfo.StopTime intValue]%1440/60;
    int min = [vechicleInfo.StopTime intValue]%1440%60;
    cell.lbStopTime.text = [NSString stringWithFormat:@"停车时长：%d天%d小时%d分钟",day,hour,min];
    cell.lbAddress.text = vechicleInfo.Location;
    WeakSelfType blockSelf = self;
    [cell.lbAddress bk_whenTapped:^{
        TruckOnMapVC *truckOnMap = [[TruckOnMapVC alloc] init];
        truckOnMap.params = @{@"subVC":@YES,@"dataArray":@[vechicleInfo]};
        [blockSelf.navigationController pushViewController:truckOnMap animated:YES];
    }];
    [cell.btnTracePlay bk_whenTapped:^{
        [blockSelf pushViewController:@"TracePlayVController" withParams:@{@"vehicleID":vechicleInfo.VID}];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VechicleInfoModel *truckInfo = self.dataArray[indexPath.row];
    [self pushViewController:@"TruckInfoVC" withParams:@{@"TruckInfo":truckInfo}];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
