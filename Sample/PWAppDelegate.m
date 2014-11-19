//
//  PWAppDelegate.m
//  PWMapKitSample
//
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import "PWAppDelegate.h"
#import <MaaSCore/MaaSCore.h>
#import <PWMapKit/PWMapKit.h>

static NSString *kMaaSCoreApplicationID = @"kMaaSCoreApplicationID";
static NSString *kMaaSCoreAccessKey = @"kMaaSCoreAccessKey";
static NSString *kMaaSCoreSignatureKey = @"kMaaSCoreSignatureKey";

@implementation PWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [PWMapKit setShouldUseZoomWorkaround:YES];
    
    NSString *applicationID = [[NSBundle mainBundle] objectForInfoDictionaryKey:kMaaSCoreApplicationID];
    NSString *accessKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:kMaaSCoreAccessKey];
    NSString *signatureKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:kMaaSCoreSignatureKey];
    
    // Register with MaaS
    [MaaSCore setApplicationID:applicationID
                     accessKey:accessKey
                  signatureKey:signatureKey
                 encryptionKey:@""];
    
    return YES;
}

@end
