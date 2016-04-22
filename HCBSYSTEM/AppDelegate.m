//
//  AppDelegate.m
//  HCBSYSTEM
//
//  Created by itte on 16/4/5.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#define BAIDUMAPKEY @"eGGnHMC2tjadWzrHCevxGgdl"

@interface AppDelegate ()
{
    BMKMapManager *bmkManager;
}

@end

@implementation AppDelegate

 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    bmkManager = [[BMKMapManager alloc] init];
    BOOL ret = [bmkManager start:BAIDUMAPKEY generalDelegate:nil];
    if (!ret) {
        NSLog(@"BMKManager start failed");
    }
    [self initAppDefaultUI];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 应用默认初始化
- (void)initAppDefaultUI
{
    //将状态栏字体改为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //改变Navibar的默认颜色
    [[UINavigationBar appearance] setBarTintColor:KNavigationBarColor];
    //设置字体为白色
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    //设置Title为白色,Title大小为18
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    [[UITabBar appearance] setBarTintColor:RGB(51, 51, 51)];
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabBar_bg"]];
}
@end
