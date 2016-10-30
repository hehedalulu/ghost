//
//  AppDelegate.m
//  妖妖灵
//
//  Created by Wll on 16/10/29.
//  Copyright © 2016年 CherryWang. All rights reserved.
//

#import "AppDelegate.h"
#include "easyar/utility.hpp"
#import "iflyMSC/IFlyMSC.h"
#import "Definition.h"
#import <BmobSDK/Bmob.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    (void)application;
    (void)launchOptions;
    _active = true;
    
    //显示SDK的版本号
    NSLog(@"verson=%@",[IFlySetting getVersion]);
    
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    //bmob环境的配置
    
    [Bmob registerWithAppKey:@"c32eaf5ec7f81e257e5edc02bb03a685"];
    //取出磁盘内部当前用户
    BmobUser *bUser = [BmobUser currentUser];
    
    //取出storyboard
    if (bUser) {
        // 取出首页的bannner
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *nav = [sb instantiateViewControllerWithIdentifier:@"FirstVC"];
        self.window.rootViewController = nav;
        NSLog(@"取出用户");
    }else{
        //取出登录的banner
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *LoginVC = [sb instantiateViewControllerWithIdentifier:@"LoginVC"];
        self.window.rootViewController = LoginVC;
        NSLog(@"没有取出用户");
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    (void)application;
    _active = false;
    EasyAR::onPause();
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    (void)application;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    (void)application;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    (void)application;
    _active = true;
    EasyAR::onResume();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    (void)application;
    _active = false;
}

@end
