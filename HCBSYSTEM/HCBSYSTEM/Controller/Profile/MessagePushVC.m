//
//  MessagePushVC.m
//  HCBSYSTEM
//
//  Created by itte on 16/4/22.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "MessagePushVC.h"
#import "MsgPushTableCell.h"

@interface MessagePushVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation MessagePushVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息推送";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MsgPushTableCell" bundle:nil] forCellReuseIdentifier:@"MsgPushTableCellID"];
}
#pragma mark - 数据初始化
- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = @[@"电子围栏",@"超速报警",@"异常停车报警",@"紧急报警",@"路线偏离报警",@"保养提醒"];
    }
    return _dataArray;
}
#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELLID = @"MsgPushTableCellID";
    MsgPushTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (cell == nil) {
        cell = [[MsgPushTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.lbText.text = self.dataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
@end
