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
#import <PWLocation/PWMockLocationStep.h>

@protocol PWMockLocationManagerDelegate;

/**
 The `PWMockLocationManager` class allows you to implement a mock provider for testing and validation. This is extremely useful for location testing when you are not able to be on location at a venue which was a proper location provider.

 It's important to note that the `floorIDMapping` property does not need to be specified for the `PWMockLocationManager`. The location floor IDs in the JSON should be equivalent to the building floor IDs.
 
 This class conforms to the `PWLocationManager` protocol.
 */

@interface PWMockLocationManager : NSObject <PWLocationManager>

/**
 The latest indoor location received from the location service.
 */
@property (nonatomic, readonly) PWIndoorLocation *location;


/**
 Initializes a mock location manager with the specified `PWMockLocationManagerConfiguration`.
 @return Returns a `PWMockLocationManager` object.
 */
- (instancetype)initWithMockLocationManagerWithConfiguration:(PWMockLocationManagerConfiguration *)configuration;

@end

