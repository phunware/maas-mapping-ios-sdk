//
//  AppDelegate.m
//  MapScenariosObjC
//
//  Created on 3/5/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import "AppDelegate.h"
#import <PWCore/PWCore.h>

// Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
static NSString *applicationId = @"";
static NSString *accessKey = @"";
static NSString *signatureKey = @"";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [PWCore setApplicationID:applicationId accessKey:accessKey signatureKey:signatureKey];
    return YES;
}

@end
