//
//  AppConfiguration.m
//  PWMapKit
//
//  Created on 8/4/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>

#import "FBBuildingManager.h"
#import "FBBuilding.h"
#import "FBBuildingsViewController.h"

#import "CommonSettings.h"
#import "MapViewController.h"

@import Firebase;

NSString *const LocalBuildingPlist = @"LocalBuilding";
NSString *const FBBuildingManagerUpdateNotification = @"PWAppConfigurationFBUpdateNotification";

@interface FBBuildingManager()

@property (nonatomic, strong) FIRDatabaseReference *rootRef;
@property (nonatomic, strong) FIRDatabaseReference *buildingsChildRef;

@end

@implementation FBBuildingManager

+ (FBBuildingManager *)shared {
    static FBBuildingManager *conf;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        conf = [FBBuildingManager new];
    });
    
    return conf;
}

- (instancetype)init {
    if (self = [super init]) {
        _rootRef = [[FIRDatabase database] referenceWithPath:@"location_tester"];
        _buildingsChildRef = [_rootRef child:@"buildings"];
        
        FBBuilding *defaultBuilding = [self defaultBuilding];
        _buildings = [[NSArray alloc] initWithObjects:defaultBuilding, nil];
        _currentBuilding = defaultBuilding;
    }
    
    return self;
}

- (void)configureBuildingObserver {
    [self.buildingsChildRef removeAllObservers];
    self.buildings = [[NSArray alloc] initWithObjects:[self defaultBuilding], nil];
    
    [self.buildingsChildRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *organizations = [[NSMutableArray alloc] init];
        for (FIRDataSnapshot *childSnapshot in [snapshot children]) {
            NSDictionary *snapshotValue = [childSnapshot value];
            if ([[snapshotValue[@"ios"] objectForKey:@"accessKey"] length] > 0) {
                FBBuilding *building = [[FBBuilding alloc] initWithSnapshotValue:snapshotValue];
                [organizations addObject:building];
            }
        }
        self.buildings = [organizations copy];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FBBuildingManagerUpdateNotification object:nil];
    }];
}

- (FBBuilding *)defaultBuilding {
    FBBuilding *building = nil;
    NSDictionary *buildings = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:LocalBuildingPlist ofType:@"plist"]];
    if ([[buildings allKeys] count] > 0) {
        NSDictionary *firstOrg = [buildings objectForKey:[[buildings allKeys] firstObject]];
        building = [[FBBuilding alloc] initWithSnapshotValue:firstOrg];
    }
    
    return building;
}

#pragma mark - UI

- (void)showBuildingsViewController:(UIViewController *)parentVC withSelectedBuildingCompletion:(FBBuildingSelectedCompletion)completion {
    FBBuildingsViewController *buildingsVC = [[FBBuildingsViewController alloc] init];
    buildingsVC.completion = completion;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:buildingsVC];
    navigationController.navigationBar.barTintColor = [CommonSettings commonNavigationBarBackgroundColor];
    navigationController.navigationBar.translucent = NO;
    [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [parentVC presentViewController:navigationController animated:YES completion:nil];
}

@end
