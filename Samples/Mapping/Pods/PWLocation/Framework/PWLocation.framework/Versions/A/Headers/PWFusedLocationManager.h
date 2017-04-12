//
//  PWFusedLocationManager.h
//  PWLocation
//
//  Copyright (c) 2014 Phunware Inc. All rights reserved.
//

#import <MapKit/MapKit.h>

#import <PWLocation/PWIndoorLocation.h>
#import <PWLocation/PWLocationManager.h>

@class PWFusedLocationManagerZone;
@class PWFusedLocationManagerZoneConfiguration;

extern NSString *const PWFusedLocationManagerDidChangeNotification;

/**
 The `PWFusedLocationManager` class defines the interface for configuring the delivery of fused location-related events to your application. The fused provider accepts an indoor location manager that conforms to the `PWLocationManager` protocol. Internally, it manages a `CLLocationManager` which it will fall back on if no indoor location updates are available. This class conforms to the `PWLocationManager` protocol.
 */
@interface PWFusedLocationManager : NSObject <PWLocationManager>

/**
 An array of `PWFusedLocationManagerZoneConfiguration` objects associated with the fused location manager.
  */
@property (nonatomic, readonly) NSArray *zoneConfigurations;

/**
  The floorIDMapping normally provides a mapping from between indoor floor identifiers and Phunware floor identifiers. This mapping is not used in the `PWFusedLocationManager` implementation. You should ensure this property is populated on the `PWLocationManager` that is passed in during initialization.
 */
@property (nonatomic, strong) NSDictionary *floorIDMapping;

/**
 The latest location received by the fused provider.
 @discussion If the latest location received is a GPS-based location the floorID property will always be `kPWUnknownFloorID`.
 */
@property (nonatomic, readonly) PWIndoorLocation *location;

/**
 Initializes the fused location manager with the specified `PWLocationManager`.
 @param locationManager - Obtained from Phunware.
 */
- (instancetype)initWithDefaultLocationManager:(id<PWLocationManager>)locationManager;

/**
 Adds a configuration object that will define a new location manager and the set of zones where that location manager should be used.
 @param zoneConfiguration The zone configuration for a new location manager
 */
- (void)addLocationManagerZoneConfiguration:(PWFusedLocationManagerZoneConfiguration *)zoneConfiguration;

/**
 Returns a Boolean value indicating whether location services are enabled on the device.
 @discussion In order for this value to return `YES` both the internal `CLLocationManager` and the `PWLocationManager` object must return `YES`.
 */
- (BOOL)locationServicesAvailable;

/**
 Starts the generation of updates that report the user’s current location.
 @discussion This method will fail if GPS and indoor location services are not available.
 */
- (void)startUpdatingLocation;

/**
 Stops updating user’s current location.
 @discussion All the internal location managers are stopped after this method is involked.
 */
- (void)stopUpdatingLocation;

/**
 Check if the specified coordinate is inside of polygon area.
 @param coordinate The coordinate to be tested.
 @param polygon The polygon to test the coordinate against.
 @return YES if it is, or else NO.
 */
- (BOOL)coordinate:(CLLocationCoordinate2D)coordinate isInsidePolygon:(MKPolygon*)polygon;

@end


