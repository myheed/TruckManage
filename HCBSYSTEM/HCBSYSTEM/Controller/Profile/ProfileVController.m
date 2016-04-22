//
//  ProfileVController.m
//  HCBTCSJ
//
//  Created by itte on 16/2/22.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "ProfileVController.h"
#import "ProfileHeaderView.h"
#import "UserLoginVController.h"

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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.headerView];
    
    [[Login sharedInstance] addObserver:self forKeyPath:@"isLogined" options:NSKeyValueObservingOptionInitial context:&ObservationContext];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
        WeakSelfType blockSelf = self;
        [_headerView.setupView bk_whenTapped:^{
            [blockSelf pushViewController:@"SetUpVController"];
        }];
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
        _imgArray = @[@"icon_modifyPwd",@"icon_msg"];
    }
    return _imgArray;
}
- (NSArray *)VCArray
{
    if (_VCArray == nil) {
        _VCArray = @[@"ResetPwdVC",@"MessagePushVC"];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:self.imgArray[indexPath.row]];
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 10, SCREEN_WIDTH, 44);
    UIView *footerView = [[UIView alloc] initWithFrame:rect];
    footerView.backgroundColor = tableView.backgroundColor;
    UILabel *lbLoginout = [[UILabel alloc] initWithFrame:rect];
    lbLoginout.text = @"退出登录";
    lbLoginout.textAlignment = NSTextAlignmentCenter;
    lbLoginout.textColor = [UIColor blackColor];
    lbLoginout.backgroundColor = [UIColor whiteColor];
    lbLoginout.userInteractionEnabled = YES;
    WeakSelfType blockSelf = self;
    [lbLoginout bk_whenTapped:^{
        [[Login sharedInstance] logout];
        UserLoginVController *loginVC = [[UserLoginVController alloc] init];
        [blockSelf presentViewController:loginVC animated:YES completion:nil];
    }];
    
    [footerView addSubview:lbLoginout];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 54;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushViewController:self.VCArray[indexPath.row] withParams:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
