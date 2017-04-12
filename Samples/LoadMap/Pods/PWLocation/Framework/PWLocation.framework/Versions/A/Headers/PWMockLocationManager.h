//
//  PWMockLocationManager.h
//  PWLocation
//
//  Copyright (c) 2014 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PWLocation/PWLocationManager.h>
#import <PWLocation/PWIndoorLocation.h>

#import <PWLocation/PWMockLocationManagerConfiguration.h>

@protocol PWMockLocationManagerDelegate;

/**
 The `PWMockLocationManager` class allows you to implement a mock location provider for testing and validation. This is extremely useful for location testing outside of a venue with a proper location provider.

 It's important to note that the `floorIDMapping` property does not need to be specified for the `PWMockLocationManager`. The location floor IDs in the JSON must be equivalent to the building floor IDs.
 
 This class conforms to the `PWLocationManager` protocol.
 */

@interface PWMockLocationManager : NSObject <PWLocationManager>

/**
 The latest indoor location received from the location service.
 */
@property (nonatomic, readonly) PWIndoorLocation *location;

/**
 Initializes a mock location manager with the specified `PWMockLocationManagerConfiguration`.
 @param configuration The `PWMockLocationManagerConfiguration` object to initialize the manager with.
 @return Returns a `PWMockLocationManager` object.
 */
- (instancetype)initWithMockLocationManagerWithConfiguration:(PWMockLocationManagerConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

@end

