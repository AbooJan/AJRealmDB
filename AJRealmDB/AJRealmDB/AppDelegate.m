//
//  AppDelegate.m
//  AJRealmDB
//
//  Created by AbooJan on 2016/11/7.
//  Copyright © 2016年 AbooJan. All rights reserved.
//

#import "AppDelegate.h"
#import "AJDBManager.h"
#import "Base64.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"%@", NSHomeDirectory());
    
    // 加密KEY,一个数据库，加密Key必须唯一,否则读取不了数据
    NSString *sourceKey = [@"A1234567890987654321qwertyuioplkjhgfdsazxcvbnm8gruodchgwpjsziub8" base64EncodedString];
    NSData *seckey = [NSData dataWithBase64EncodedString:sourceKey];
    
    NSLog(@"#secKey-data#: %@", seckey); // 在电脑上读取加密后的数据库时可以使用这串16进制Key
    
//    [AJDBManager configSecurityKey:seckey];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
