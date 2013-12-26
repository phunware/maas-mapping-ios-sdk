//
//  AppDelegate.m
//  PWMapKitSamples
//
//  Created by Devin Pigera on 12/17/13.
//  Copyright (c) 2013 Phunware Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

#import <MaaSCore/MaaSCore.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
#warning Update these values 
    [MaaSCore setApplicationID:@"98"
                     accessKey:@"386a54d2be73d160601b7cfe759387ba702e3623"
                  signatureKey:@"b434ae3a0fa7a41d516e8b34d3021bce33f66cf1"
                 encryptionKey:@"nada"];
    
    
    RootViewController *rootViewController = [[RootViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];

    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //
}

@end
