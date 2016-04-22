//
//  ProfileVController.m
//  HCBTCSJ
//
//  Created by itte on 16/2/22.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "ProfileVController.h"
#import "ProfileHeaderView.h"

#define KHeightOfHeaderView       100
#define KWidthOfHeadImage         80

#define KButtonWidth              120
#define KButtonTop                100

@interface ProfileVController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// HeaderView相关控件
@property (strong, nonatomic) ProfileHeaderView *headerView;


// table相关数据
@property (retain, nonatomic) NSArray *dataArray;
@property (retain, nonatomic) NSArray *imgArray;
@property (retain, nonatomic) NSArray *VCArray;
@end

@implementation ProfileVController

static void *ObservationContext = &ObservationContext;
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setHidden:YES];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.headerView];
    
    [[Login sharedInstance] addObserver:self forKeyPath:@"isLogined" options:NSKeyValueObservingOptionInitial context:&ObservationContext];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blueColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == ObservationContext) {
        [self updateHeaderView];
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)updateHeaderView
{
    if ([Login sharedInstance].isLogined) {
        
    }
}

#pragma mark - 数据初始化
- (ProfileHeaderView *)headerView
{
    if (_headerView == nil) {
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 240);
        _headerView = [[ProfileHeaderView alloc] init];
        _headerView.frame = rect;
    }
    return _headerView;
}
- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = @[@"修改密码",@"消息推送"];
    }
    return _dataArray;
}

-(NSArray *)imgArray
{
    if (_imgArray == nil) {
        _imgArray = @[@"wallet",@"reportTable"];
    }
    return _imgArray;
}
- (NSArray *)VCArray
{
    if (_VCArray == nil) {
        _VCArray = @[@"",@""];
    }
    return _VCArray;
}


#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELLID = @"PROFILLCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELLID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushViewController:self.VCArray[indexPath.row] withParams:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
