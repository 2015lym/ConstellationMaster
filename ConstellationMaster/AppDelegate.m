//
//  AppDelegate.m
//  ConstellationMaster
//
//  Created by Lym on 16/3/27.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MyCareViewController.h"
#import "SettingViewController.h"
#import "PersonViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UITabBarController *MainTBC=[[UITabBarController alloc]init];  //设置MainTBC
    
/*------------------------------------------------------*/
/*+++             设置各个Controller                  +++*/
/*------------------------------------------------------*/
    MainViewController *MainVC=[[MainViewController alloc]init];
    MainVC.tabBarItem.image=[UIImage imageNamed:@"1"];
    UINavigationController *nc1=[[UINavigationController alloc]initWithRootViewController:MainVC];
    MainVC.title=@"今日运势";
    
    MyCareViewController *MyCareVC=[[MyCareViewController alloc]init];
    MyCareVC.tabBarItem.image=[UIImage imageNamed:@"2"];
    UINavigationController *nc2=[[UINavigationController alloc]initWithRootViewController:MyCareVC];
    MyCareVC.title=@"我的关注";
    
    SettingViewController *SettingVC=[[SettingViewController alloc]init];
    SettingVC.tabBarItem.image=[UIImage imageNamed:@"3"];
    UINavigationController *nc3=[[UINavigationController alloc]initWithRootViewController:SettingVC];
    SettingVC.title=@"系统设置";
    
    PersonViewController *PersonVC=[[PersonViewController alloc]init];
    PersonVC.tabBarItem.image=[UIImage imageNamed:@"4"];
    UINavigationController *nc4=[[UINavigationController alloc]initWithRootViewController:PersonVC];
    PersonVC.title=@"我的信息";
    
/*      -----将各个Controller添加到MainTBC-----      */
    
    MainTBC.viewControllers=@[nc1,nc2,nc3,nc4];
    self.window.rootViewController=MainTBC;        //根控制器
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}
@end
