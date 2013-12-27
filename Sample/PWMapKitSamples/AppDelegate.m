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
    [MaaSCore setApplicationID:@"YOUR_APPLICATION_ID"
                     accessKey:@"YOUR_ACCESS_KEY"
                  signatureKey:@"YOUR_SIGNATURE_KEY"
                 encryptionKey:@"UNUSED"];
    
    
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
