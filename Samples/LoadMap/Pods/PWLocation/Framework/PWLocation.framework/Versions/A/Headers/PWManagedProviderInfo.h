//
//  PWManagedProviderInfo.h
//  PWLocation
//
//  Created on 2/2/17.
//  Copyright © 2017 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PWManagedProviderType) {
    PWManagedProviderTypeSenion = 0,
    PWManagedProviderTypeCMX = 1,
    PWManagedProviderTypeBeaconPoint = 2,
    PWManagedProviderTypeMist = 3
};

@interface PWManagedProviderInfo : NSObject

/**
 The provider type.
 */
@property (nonatomic, readonly) PWManagedProviderType providerType;

/**
 The provider name.
 */
@property (nonatomic, strong, readonly) NSString *providerName;

/**
 isActive is YES if the provider is active in the PWManagedLocationManager
 */
@property (nonatomic, assign, readonly) BOOL isActive;

/**
 The confidence factor of the provider, on a scale of 0 (least confident) to 1 (most confident).
 */
@property (nonatomic, strong, readonly) NSNumber *confidenceFactor;

- (instancetype)init NS_UNAVAILABLE;

@end
