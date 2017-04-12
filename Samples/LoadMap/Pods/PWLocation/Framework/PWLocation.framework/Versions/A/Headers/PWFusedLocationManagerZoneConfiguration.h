//
//  PWFusedLocationManagerZoneConfiguration.h
//  PWLocation
//
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PWLocationManager;

/**
 The 'PWFusedLocationManagerZoneConfiguration' class relates a location manager to the zones where the location manager should be used.
 */
@interface PWFusedLocationManagerZoneConfiguration : NSObject

/** The location manager object */
@property (readonly) id<PWLocationManager> locationManager;
/** An array of zones where the location manager should be used */
@property (readonly) NSArray /* PWFusedLocationManagerZone */ *zones;

/**
 Initializes a 'PWFusedLocationManagerZoneConfiguration' object with a location manager along with the zones where the location manager will be valid
 @param locationManager A location manager object
 @param zones The zones where the location manager will be valid
 @return An initialized 'PWFusedLocationManagerZoneConfiguration' object.
 */
- (instancetype)initWithLocationManager:(id<PWLocationManager>)locationManager zones:(NSArray /* PWFusedLocationManagerZone */ *)zones NS_DESIGNATED_INITIALIZER;

@end
