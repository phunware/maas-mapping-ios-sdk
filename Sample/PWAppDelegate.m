//
//  PWAppDelegate.m
//  PWMapKitSample
//
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import "PWAppDelegate.h"
#import <MaaSCore/MaaSCore.h>
//#import <Crashlytics/Crashlytics.h>

#import "PWMapKit.h"

static NSString *kMaaSCoreApplicationID = @"kMaaSCoreApplicationID";
static NSString *kMaaSCoreAccessKey = @"kMaaSCoreAccessKey";
static NSString *kMaaSCoreSignatureKey = @"kMaaSCoreSignatureKey";
static NSString *kMaaSCoreEncryptionKey = @"kMaaSCoreEncryptionKey";

@implementation PWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *applicationID = [[NSBundle mainBundle] objectForInfoDictionaryKey:kMaaSCoreApplicationID];
    NSString *accessKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:kMaaSCoreAccessKey];
    NSString *signatureKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:kMaaSCoreSignatureKey];
    NSString *encryptionKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:kMaaSCoreEncryptionKey];

    //[Crashlytics startWithAPIKey:@"b8127086af392cb1b73dc00a7387bb7a0856138f"];
    
    // Register with MaaS
    [MaaSCore setApplicationID:applicationID
                     accessKey:accessKey
                  signatureKey:signatureKey
                 encryptionKey:encryptionKey];

    return YES;
}

@end
