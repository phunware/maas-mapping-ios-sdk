//
//  AppDelegate.m
//  LoadMap
//
//  Created on 7/25/16.
//  Copyright © 2016 Phunware Inc. All rights reserved.
//

#import <PWCore/PWCore.h>
#import "AppDelegate.h"

#define kAppID @"1383"
#define kAccessKey @"aca26bfdc28d44faf6a4f072bd6960e232970ff0"
#define kSignatureKey @"fe53376845e917bf9ccc480bbc09f22c6e125ea3"
#define kEncryptionKey @"<Encrytion Key>"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [PWCore setApplicationID:kAppID
                   accessKey:kAccessKey
                signatureKey:kSignatureKey
               encryptionKey:kEncryptionKey];
        
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

@end
