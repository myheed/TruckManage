//
//  UserLoginVController.m
//  HCBTCSJ
//
//  Created by itte on 16/2/23.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "UserLoginVController.h"

@interface UserLoginVController ()<UITextFieldDelegate>
{
    BOOL bRecordPasswd;
}
@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPasswd;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnTestUser;
@property (weak, nonatomic) IBOutlet UIView *recordPwdView;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheckBox;
@property (weak, nonatomic) IBOutlet UILabel *lbCallService;
@end

@implementation UserLoginVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logoView.backgroundColor = KNavigationBarColor;
    
    bRecordPasswd = NO;
    // 是否记住密码
    [self.recordPwdView bk_whenTapped:^{
        bRecordPasswd = !bRecordPasswd;
        NSString *img = (bRecordPasswd)?@"chkBox_select":@"chkBox_noselect";
        [self.imgCheckBox setImage:[UIImage imageNamed:img]];
    }];
    // 呼叫客服
    self.lbCallService.userInteractionEnabled = YES;
    [self.lbCallService bk_whenTapped:^{
        NSString *phoneNum = self.lbCallService.text.trimString;
        [phoneNum CallPhone];
    }];
    self.btnTestUser.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnTestUser.layer.borderWidth = 1.0;
    self.btnTestUser.layer.cornerRadius = 5.0;
    self.btnLogin.layer.cornerRadius = 5.0;
    
    UIView *leftPhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imgPhoneView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_user"]];
    imgPhoneView.frame = CGRectMake(15, 12, 15, 15);
    [leftPhoneView addSubview:imgPhoneView];
    UIView *leftPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imgPwdView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pwd"]];
    imgPwdView.frame = CGRectMake(15, 12, 15, 15);
    [leftPwdView addSubview:imgPwdView];
    self.txtUserName.leftView = leftPhoneView;
    self.txtPasswd.leftView = leftPwdView;
    self.txtUserName.leftViewMode = UITextFieldViewModeAlways;
    self.txtPasswd.leftViewMode = UITextFieldViewModeAlways;
    self.txtUserName.delegate = self;
    self.txtPasswd.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardExit)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 键盘事件
- (void)keyboardExit
{
    [self.txtUserName resignFirstResponder];
    [self.txtPasswd resignFirstResponder];
    WeakSelfType _blockSelf = self;
//    [UIView animateWithDuration:0.2 animations:^{
//        _blockSelf.view.top = 0;
//    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    WeakSelfType _blockSelf = self;
//    [UIView animateWithDuration:0.2 animations:^{
//        _blockSelf.view.top = -50;
//    }];
}

#pragma mark - 登录注册忘记密码点击事件
// 登录
- (IBAction)btnLoginClick
{

    NSString *cellPhone = [self.txtUserName.text trimString];
    if ([cellPhone isEmpty]) {
        [self showResultThenHide:@"请输入用户名!"];
        return ;
    }
    NSString *passwd = [self.txtPasswd.text trimString];
    if ([passwd isEmpty]) {
        [self showResultThenHide:@"请输入密码!"];
        return ;
    }

    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setObject:cellPhone forKey:@"UserName"];
    [dictParam setObject:passwd forKey:@"Password"];

    [[AFNetworkManager sharedInstance] AFNHttpRequestWithAPI:KLogin andDictParam:dictParam requestSuccessed:^(id responseObject) {
        NSArray *data = [UserModel mj_objectArrayWithKeyValuesArray:responseObject];
        UserModel *user = data[0];
        if ([user.userID integerValue] > 0) {
            [self showResultThenHide:@"登录成功"];
            [[Login sharedInstance] login:user withRecordPwd:bRecordPasswd];
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }
        else{
            [self showResultThenHide:@"登录失败"];
        }
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self showResultThenHide:@"登录失败"];
    }];
}

// 系统演示
- (IBAction)btnTestUserClick
{
    [self pushViewController:@"RegisterVController" withParams:@{@"operateType":@"0"}];
}



@end
