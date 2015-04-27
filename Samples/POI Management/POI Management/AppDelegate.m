//
//  AppDelegate.m
//  POI Management
//
//  Created by Illya Busigin on 4/13/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <MaaSCore/MaaSCore.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#warning Please specify your keys before running the sample
    [MaaSCore setApplicationID:@"YOUR_APPLICATION_ID"
                     accessKey:@"YOUR_ACCESS_KEY"
                  signatureKey:@"YOUR_SIGNATURE_KEY"
                 encryptionKey:@""];
    
    return YES;
}

@end
