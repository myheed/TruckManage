//
//  RootNaviVCtroller.m
//  HCB
//
//  Created by user on 16/2/20.
//  Copyright (c) 2016年 funmain. All rights reserved.
//

#import "RootNaviVCtroller.h"

#define KTabbarTextColor RGB(255, 216, 0)

@implementation CarBarnNaviVCtroller
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarItem:self.tabBarItem withTitle:@"我的车库" withTitleSize:13.0 selectedImage:[UIImage imageNamed:@"tabbar_car_sel"] selectedTitleColor:KTabbarTextColor unselectedImage:[UIImage imageNamed:@"tabbar_car_nor"]  unselectedTitleColor:[UIColor whiteColor]];
}
@end

@implementation AlertCenterNaviVCtroller
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarItem:self.tabBarItem withTitle:@"报警中心" withTitleSize:13.0 selectedImage:[UIImage imageNamed:@"tabbar_mes_sel"] selectedTitleColor:KTabbarTextColor unselectedImage:[UIImage imageNamed:@"tabbar_mes_nor"]  unselectedTitleColor:[UIColor whiteColor]];
}
@end

@implementation ProfileNaviVCtroller
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarItem:self.tabBarItem withTitle:@"个人中心" withTitleSize:13.0 selectedImage:[UIImage imageNamed:@"tabbar_user_sel"] selectedTitleColor:KTabbarTextColor unselectedImage:[UIImage imageNamed:@"tabbar_user_nor"]  unselectedTitleColor:[UIColor whiteColor]];
}
@end


@implementation BaseNaviVCtroller
- (void)viewDidLoad
{
    [super viewDidLoad];
}

// 自定义tabbar
- (void)setTabBarItem:(UITabBarItem *)tabBarItem
            withTitle:(NSString *)title
        withTitleSize:(CGFloat)titleSize
        selectedImage:(UIImage *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
      unselectedImage:(UIImage *)unselectedImage
 unselectedTitleColor:(UIColor *)unselectColor
{
    //设置图片
    tabBarItem = [tabBarItem initWithTitle:title image:[unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // 未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont systemFontOfSize:titleSize]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont systemFontOfSize:titleSize]} forState:UIControlStateSelected];
}

@end