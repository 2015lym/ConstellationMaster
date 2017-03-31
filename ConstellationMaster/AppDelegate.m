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
{
    UITabBarController *mainTBC;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    mainTBC=[[UITabBarController alloc]init];
    
    /*-------------------------------------------------*/
    /*                  设置各个Controller               */
    /*-------------------------------------------------*/
    MainViewController *vc1 = [[MainViewController alloc]init];
    [self setController:vc1 andTitle:@"今日运势" andImageName:@"1"];
    UINavigationController *nc1 = [self setNavigationController:vc1];
    
    MyCareViewController *vc2 = [[MyCareViewController alloc]init];
    [self setController:vc2 andTitle:@"我的关注" andImageName:@"2"];
    UINavigationController *nc2 = [self setNavigationController:vc2];
    
    SettingViewController *vc3 = [[SettingViewController alloc]init];
    [self setController:vc3 andTitle:@"系统设置" andImageName:@"3"];
    UINavigationController *nc3 = [self setNavigationController:vc3];
    
    PersonViewController *vc4 = [[PersonViewController alloc]init];
    [self setController:vc4 andTitle:@"我的信息" andImageName:@"4"];
    UINavigationController *nc4 = [self setNavigationController:vc4];
    
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
/*      -----将各个Controller添加到mainTBC-----      */
    mainTBC.viewControllers = @[nc1,nc2,nc3,nc4];
    self.window.rootViewController = mainTBC;        //根控制器
    
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

#pragma mark - ---------- 设置VC基本信息 ----------
- (void)setController:(UIViewController *)vc andTitle:(NSString *)title andImageName:(NSString *)imageString
{
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageString];
}

#pragma mark - ---------- 设置NVC基本信息 ----------
- (UINavigationController *)setNavigationController:(UIViewController *)vc
{
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [nvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return nvc;
}

@end
