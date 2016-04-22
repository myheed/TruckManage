//
//  BaseVController.h
//  IFP
//
//  Created by user on 16/2/20.
//  Copyright (c) 2016年 funmain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "JLTipsView.h"

#define WeakSelfType __weak __typeof(&*self)
#define kHudIntervalNormal 1.5f

@interface BaseVController : UIViewController
// 显示该视图控制器的时候传入的参数
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) JLTipsView *tipsView; // 提示信息，默认隐藏
@property (assign, nonatomic) BOOL isTipsViewShow;   // 是否显示提示View

#pragma mark - push & pop & dismiss view controller
- (void)pushViewController:(NSString *)className;
- (void)pushViewController:(NSString *)className withParams:(NSDictionary *)paramDict;
-(void)presentViewcontroller:(NSString *)className animated:(BOOL)flag;
//返回上一级
- (void)popViewController;
//返回到根
- (void)popToRootViewController;

#pragma mark - 显示或者隐藏HUD
- (MBProgressHUD *)showHUDLoadingWithString:(NSString *)hintString;
- (MBProgressHUD *)showHUDLoadingWithString:(NSString *)hintString onView:(UIView *)view;
- (MBProgressHUD *)showHUDLoading;
- (void)hideHUDLoading;
- (void)hideHUDLoadingOnView:(UIView *)view;
- (void)showResultThenHide:(NSString *)resultString;
- (void)showResultThenHide:(NSString *)resultString
                afterDelay:(NSTimeInterval)delay
                    onView:(UIView *)view;
- (void)showResult:(NSString *)resultString
         WithImage:(UIImage *)image;
- (void)showSuccessResult:(NSString *)success;
- (void)showFaildResult:(NSString *)faild;

-(void)backup;
-(void)loadCache;
#pragma mark - 设置圆形头像
-(void)setCircleHeadImage:(UIImageView *)headImg;
@end
