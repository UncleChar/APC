//
//  AppDelegate.m
//  AiPaChe
//
//  Created by LingLi on 16/3/17.
//  Copyright © 2016年 Char. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#define kAK @"j3HFMj8e71si0vqjM8poPk5U"
@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)getAPCDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"j3HFMj8e71si0vqjM8poPk5U" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [[UINavigationBar appearance]setBarTintColor:[ConfigUITools colorWithR:60 G:60 B:59 A:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
//    [[UINavigationBar appearance]setBarTintColor:[ConfigUITools colorWithR:200 G:60 B:61 A:1]];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setTranslucent:NO];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kUserLoginStatus]) {
        
        
//        self.window.rootViewController = [[MainTabBarController alloc]init];
        
    }else {
        
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[MainViewController alloc]init]];
        
    }
    
    
    
    
    [self.window makeKeyAndVisible];
    
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
+ (BOOL)isNetworkConecting {
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kNetworkConnecting]) {
        
        return YES;
        
    }else {
        
        return NO;
        
    }
    
}
@end
