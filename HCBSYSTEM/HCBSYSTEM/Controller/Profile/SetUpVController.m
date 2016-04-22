//
//  SetUpVController.m
//  HCBTCHZ
//
//  Created by itte on 16/3/28.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "SetUpVController.h"

@interface SetUpVController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *dataArray;
@property (retain, nonatomic) NSArray *imgArray;
@property (retain, nonatomic) NSArray *VCArray;
@end

@implementation SetUpVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}
#pragma mark - 数据初始化
- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = @[@"关于我们",@"意见反馈"];
    }
    return _dataArray;
}

- (NSArray *)VCArray
{
    if (_VCArray == nil) {
        _VCArray = @[@"AboutVController",@"FeedbackVController"];
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
    static NSString *CELLID = @"SetupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELLID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushViewController:self.VCArray[indexPath.row] withParams:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
