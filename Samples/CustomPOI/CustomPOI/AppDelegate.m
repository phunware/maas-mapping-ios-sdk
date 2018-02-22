//
//  AppDelegate.m
//  CustomPOI
//
//  Copyright © 2017 Phunware Inc. All rights reserved.
//

#import <PWCore/PWCore.h>

#import "AppDelegate.h"

/* 
 Getting following keys from Phunware MaaS portal at https://maas.phunware.com/n/account/apps , by choosing an iOS app >> click the most right button >> select the "Show Keys" on the drop list.
*/
#define kAppID @"<App Identifier>"        // the App ID
#define kAccessKey @"<Access Key>"        // the Access Key
#define kSignatureKey @"<Signature Key>"  // the Signature Key
#define kEncryptionKey @""                // keep it empty

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [PWCore setApplicationID:kAppID
                   accessKey:kAccessKey
                signatureKey:kSignatureKey];
    
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
