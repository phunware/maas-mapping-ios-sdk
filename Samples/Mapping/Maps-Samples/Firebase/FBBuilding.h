//
//  PWBuilding.h
//  PWLocation
//
//  Created by Chesley Stephens on 2/23/17.
//  Copyright © 2017 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PWCore+Private.h"

@class PWManagedLocationManager;

typedef NS_ENUM(NSInteger, FBProviderType) {
    FBProviderTypeCMX,
    FBProviderTypeManaged,
    FBProviderTypeSenion
};

@interface FBBuilding : NSObject

@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *bpOrgId;
@property (nonatomic, strong) NSNumber *buildingId;
@property (nonatomic, strong) NSString *cmxGuid;
@property (nonatomic, strong) NSDictionary *cmxFloors;
@property (nonatomic, assign) PWEnvironment environment;
@property (nonatomic, strong) PWManagedLocationManager *managedLocationManager;
@property (nonatomic, strong) NSString *mistOrgId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *senionMaasFloorMap;
@property (nonatomic, strong) NSString *senionId;
@property (nonatomic, strong) NSString *senionMapKey;
@property (nonatomic, strong) NSString *signatureKey;
@property (nonatomic, strong) NSArray  *supportedTypes;
@property (nonatomic, assign) FBProviderType providerType;

- (instancetype)initWithSnapshotValue:(NSDictionary *)snapshotValue;

+ (NSString *)stringForProviderType:(FBProviderType)type;
- (void)configureManagedLocationManager;

@end
