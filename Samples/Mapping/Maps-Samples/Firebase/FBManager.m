//
//  PWFirebaseManager.m
//  PWLocation
//
//  Created by Chesley Stephens on 2/27/17.
//  Copyright © 2017 Phunware Inc. All rights reserved.
//

#import "FBManager.h"
#import "FBBuildingManager.h"

#import "AppDelegate.h"
#import "MapViewController.h"
#import "CommonSettings.h"

@import Firebase;

@interface FBManager()

@property (nonatomic, strong) FBBuildingManager *buildingManager;

@end

@implementation FBManager

+ (FBManager *)shared {
    static FBManager *conf;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        conf = [FBManager new];
    });
    
    return conf;
}

- (instancetype)init {
    if (self = [super init]) {
        [FIRApp configure];
        _buildingManager = [FBBuildingManager shared];
    }
    
    return self;
}

- (void)configureWithAppDelegate:(AppDelegate *)appDelegate {
    if ([[FIRAuth auth] currentUser] == nil) {
        [self authenticateWithFirebase];
    } else {
        [[FBBuildingManager shared] configureBuildingObserver];
    }
    
    [self showMapViewController:appDelegate];
}

- (void)authenticateWithFirebase {
    __weak FBManager *weakSelf = self;
    [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
        [weakSelf.buildingManager configureBuildingObserver];
    }];
}

- (void)showMapViewController:(AppDelegate *)appDelegate {
    appDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MapViewController *mapKitController = [[MapViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapKitController];
    navigationController.navigationBar.barTintColor = [CommonSettings commonNavigationBarBackgroundColor];
    appDelegate.window.rootViewController = navigationController;
    [appDelegate.window makeKeyAndVisible];
}

@end
