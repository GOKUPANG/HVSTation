//
//  AppDelegate.m
//  HV station
//
//  Created by sswukang on 2016/10/19.
//  Copyright © 2016年 sswukang. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeController.h"
#import "RegisterController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //判断是否第一次启动app
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:firstLaunch]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstLaunch];
        //第一次启动
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        
        NSLog(@"第一次启动");
        
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        
        HomeController *home = [[HomeController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:home];
        
        RegisterController * rec = [[RegisterController alloc]init];
        
        
        [home.navigationController pushViewController:rec animated:NO];
        
        UINavigationBar *bar = [UINavigationBar appearance];
        bar.hidden = YES;
        bar.barStyle = UIBarStyleBlack;
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
    }
    
    
    
    else
    {
        
        
       // [[NSUserDefaults standardUserDefaults] setBool:NO forKey:firstLaunch];

        //不是第一次启动了
        
        	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"everLaunched"];
        
        
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        HomeController *home = [[HomeController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:home];
        
                
        UINavigationBar *bar = [UINavigationBar appearance];
        bar.hidden = YES;
        bar.barStyle = UIBarStyleBlack;
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        

        
        NSLog(@"不是第一次启动了");
        
        
    }
    
    
        return YES;
}

@end
