//
//  AppConfiguration.h
//  PWMapKit
//
//  Created on 8/4/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBBuilding.h"

extern NSString *const FBBuildingManagerUpdateNotification;

typedef void (^FBBuildingSelectedCompletion) (void);

@interface FBBuildingManager : NSObject

@property (nonatomic, strong) NSArray *buildings;
@property (nonatomic, strong) FBBuilding *currentBuilding;

+ (FBBuildingManager *)shared;

- (void)configureBuildingObserver;
- (void)showBuildingsViewController:(UIViewController *)parentVC withSelectedBuildingCompletion:(FBBuildingSelectedCompletion)completion;

@end
