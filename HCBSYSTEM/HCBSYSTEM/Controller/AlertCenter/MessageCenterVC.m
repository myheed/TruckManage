//
//  MessageCenterVC.m
//  HCBSYSTEM
//
//  Created by itte on 16/4/19.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "MessageCenterVC.h"
#import "MessageTableCell.h"

@interface MessageCenterVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSString *searKey;
    NSInteger pageIndex;
    BOOL bItemEdit;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;
@property (strong, nonatomic) UITextField *txtSearch;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation MessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    searKey = @"";
    pageIndex = 1;
    bItemEdit = NO;
    self.dataArray = [NSMutableArray array];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 175;
    WeakSelfType weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 1;
        [weakSelf loadNetworkData];
    }];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf loadNetworkData];
//    }];
    [_tableView registerNib:[UINib nibWithNibName:@"MessageTableCell" bundle:nil] forCellReuseIdentifier:@"MessageTableCellID"];
    
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.maskView.top = self.view.bottom;
    self.maskView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:self.maskView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardExit)];
    [self.maskView addGestureRecognizer:tapGesture];
    
    [self itemEdit];
}

- (void)itemEdit
{
    // 非编辑状态
    if (!bItemEdit){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(btnEdtClick)];
        self.tableBottomConstraint.constant = 0;
    }
    // 编辑状态
    else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(btnEdtClick)];
        self.tableBottomConstraint.constant = 44;
    }
    [self.tableView reloadData];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (void)btnEdtClick
{
    bItemEdit = !bItemEdit;
    [self itemEdit];
}

#pragma mark - textField相关操作
-(UITextField *)txtSearch
{
    if (_txtSearch == nil) {
        _txtSearch = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 30)];
        _txtSearch.backgroundColor = [UIColor whiteColor];
        _txtSearch.layer.cornerRadius = 15;
        _txtSearch.returnKeyType = UIReturnKeySearch;
        _txtSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtSearch.delegate = self;
        _txtSearch.placeholder = @"车牌号";
    }
    return _txtSearch;
}
- (void)keyboardExit
{
    [UIView animateWithDuration:0.1 animations:^{
        self.maskView.top = self.view.bottom;
    }];
    [self.txtSearch resignFirstResponder];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.maskView.top = self.view.bottom;
    [UIView animateWithDuration:0.1 animations:^{
        self.maskView.top = 0;
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self keyboardExit];
    searKey = textField.text.trimString;
//    pageIndex = 1;
    [self.dataArray removeAllObjects];
    [self.tableView.mj_header beginRefreshing];
    return YES;
}

#pragma mark - 网络处理
- (void)loadNetworkData
{
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;//self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableCellID"];
    if (cell == nil) {
        cell = [[MessageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TruckInfoTableCellID"];
    }
    cell.btnMsgType.layer.cornerRadius = 25;
    cell.btnCallDriver.layer.cornerRadius = 5;
    cell.btnOpration.layer.cornerRadius = 5;
    [cell.imgChoice setHidden:!bItemEdit];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 11;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 编辑状态
    if (bItemEdit) {
        
    }
    else{
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
