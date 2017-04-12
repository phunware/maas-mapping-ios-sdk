//
//  PWManagedLocationManager.h
//
//  Copyright © 2016 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWLocation/PWLocationManager.h>
#import <PWLocation/PWIndoorLocation.h>

@interface PWManagedLocationManager : NSObject <PWLocationManager>

/**
 The building identifier.
 */
@property (nonatomic, readonly) NSInteger buildingId;

/**
 The last indoor location received.
 */
@property (nonatomic, readonly) PWIndoorLocation *location;

/**
 The floor ID mapping dictionary used to define the mapping between the location provider floor ID and the Phunware floor ID. The dictionary format must adhere to the following format: `@{CUSTOMER_FLOORID : PHUNWARE_FLOOR_ID}`.
 */
@property (nonatomic, strong) NSDictionary *floorIDMapping;

/**
 Initialize with a building identifier.
 @param buildingId The building identifier.
 */
- (instancetype)initWithBuildingId:(NSInteger)buildingId;

- (instancetype)init NS_UNAVAILABLE;

+ (void)createWithBundleURL:(NSURL *)bundleURL completion:(void(^)(PWManagedLocationManager *managedLocationManager, NSError *error))completion;

/**
 Returns an array of PWManagedProviderInfo objects. Each provider will have its own PWManagedProviderInfo object. This will return nothing if the bundle has not already been loaded by a completed startUpdatingLocation call.
 */
- (NSArray *)internalProviderInformation;

@end
