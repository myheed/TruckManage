//
//  MainTabBarVC.m
//  HCBSYSTEM
//
//  Created by itte on 16/4/5.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "MainTabBarVC.h"
#import "UserLoginVController.h"

@interface MainTabBarVC ()
@property (strong, nonatomic) UserLoginVController *loginVC;
@end

@implementation MainTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if(![Login sharedInstance].isLogined)
    {
        self.loginVC = [[UserLoginVController alloc] init];
        self.loginVC.view.frame = self.view.bounds;
        [self.view addSubview:self.loginVC.view];
        [self.loginVC.view bringSubviewToFront:self.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
