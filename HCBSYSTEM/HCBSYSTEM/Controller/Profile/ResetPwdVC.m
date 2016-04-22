//
//  ResetPwdVC.m
//  HCBSYSTEM
//
//  Created by itte on 16/4/22.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "ResetPwdVC.h"

@interface ResetPwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *txtCurPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPwdConfirm;

@end

@implementation ResetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardExit)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)keyboardExit
{
    [self.txtCurPwd resignFirstResponder];
    [self.txtNewPwd resignFirstResponder];
    [self.txtNewPwdConfirm resignFirstResponder];
}

- (void)submit
{
}
@end
