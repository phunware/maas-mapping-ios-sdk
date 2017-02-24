//
//  AppDelegate.m
//  Sample
//
//  Created on 8/4/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWCore/PWCore.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import <PWMapKit/PWMapKit.h>

#import "AppDelegate.h"
#import "SimpleConfiguration.h"
#import "RouteAccessibilityManager.h"
#import "ConfirmVoiceOverViewController.h"
#import "MapViewController.h"
#import "CommonSettings.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];
    
    [RouteAccessibilityManager sharedInstance].locationDistanceUnit = LocationDistanceUnitFeet;
    [RouteAccessibilityManager sharedInstance].directionType = DirectionTypeOClock;
    
    __weak typeof(self) weakSelf = self;
    [[SimpleConfiguration sharedInstance] fetchConfiguration:^(NSDictionary *conf, NSError *error) {
        [PWCore setApplicationID:conf[@"appId"]
                       accessKey:conf[@"accessKey"]
                    signatureKey:conf[@"signatureKey"]
                   encryptionKey:conf[@"encryptionKey"]?:@""];
        
        weakSelf.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        if (UIAccessibilityIsVoiceOverRunning() && ![[NSUserDefaults standardUserDefaults] boolForKey:VoiceOverConfirmedKey]) {
            ConfirmVoiceOverViewController *voiceOverController = [ConfirmVoiceOverViewController new];
            weakSelf.window.rootViewController = voiceOverController;
        } else {
            MapViewController *mapKitController = [[MapViewController alloc] initWithBuildingConfiguration:conf[@"buildings"][0]];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapKitController];
            navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0118 green:0.3961 blue:0.7529 alpha:1.0];
            weakSelf.window.rootViewController = navigationController;
        }
        
        [self.window makeKeyAndVisible];
        
        if (error) {
            NSLog(@"fetchConfiguration Error: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *problemLoadingAlert = [UIAlertController alertControllerWithTitle:nil message:PWLocalizedString(@"ProblemLoadingAlert", @"There was a problem loading the configuration.") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okayAction = [UIAlertAction actionWithTitle:PWLocalizedString(@"Okay", @"Okay") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                }];
                [problemLoadingAlert addAction:okayAction];
                [weakSelf.window.rootViewController presentViewController:problemLoadingAlert animated:YES completion:nil];
            });
        }
    }];
    
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
