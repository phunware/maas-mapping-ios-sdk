//
//  PWBeaconLocationManager.h
//  PWLocation
//
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWLocation/PWIndoorLocation.h>
#import <PWLocation/PWLocationManager.h>

typedef NS_ENUM(NSUInteger, PWBLMError) {
    PWBLMErrorRangingUnavailable,
    PWBLMErrorRangingFailure,
    PWBLMErrorDenied
};

extern NSUInteger const PWBeaconLocationManagerMaximumRegionsToMonitorLimit;
extern NSUInteger const PWBeaconLocationManagerDefaultMaximumRegionsToMonitor;

@protocol PWBeaconProximityManagerDelegate;

/**
 The `PWBeaconProximityManager` class defines the interface for configuring the delivery of beacon proximity-related events to your application. You use an instance of this class to establish the parameters that determine when beacon proximity events should be delivered and to start and stop the actual delivery of those events.
 
 The beacon proximity provider receives location data from multiple beacons and selected the closest beacon over a given time period to promote as the current location. While beacon proximity will update fairly frequently (1-2 times/second) the accuracy is suspect and should not be relied on for fine-grained location updates.
 */
@interface PWBeaconProximityManager : NSObject <PWLocationManager>

/**
 The `CLLocationManager` used to deliver beacon location updates.
 @discussion You are responsible for requesting permission to use location services. The `CLLocationManagerDelegate` of this instance is owned by the `PWGPSLocationManager` instance. Modifying this location manager directly may have adverse affects on beacon location updates.
 */
@property (nonatomic, readonly) CLLocationManager *internalLocationManager;
@property (nonatomic, readonly) NSArray *beaconRegions;

@property (nonatomic, readwrite) NSUInteger maximumBeaconRegionsToMonitor;

/**
 The floor ID mapping dictionary used to define the mapping between the location provider floor ID and the Phunware floor ID. The dictionary format must adhere to the following format: `@{CUSTOMER_FLOORID : PHUNWARE_FLOOR_ID}`.
 */
@property (nonatomic, strong) NSDictionary *floorIDMapping;

/**
 The most recently retrieved indoor location.
 
 @discussion The value of this property is nil if no location data has ever been retrieved.
 */
@property (nonatomic, readonly) PWIndoorLocation *location;

- (instancetype)initWithCLLocationManager:(CLLocationManager *)locationManager beaconRegions:(NSArray * /* PWBeaconProximityRegion */)beaconRegions NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

///-------------------------------------------
/// @name Determining Availability of Services
///-------------------------------------------

/**
 Returns a Boolean value indicating whether location services are enabled on the device.
 @discussion In order to fetch the user's location, the manager must be within proximity of the venue and have retrieved specific device information from Phunware's servers.
 */
- (BOOL)locationServicesAvailable;

///----------------------------------
/// @name Initiating Location Updates
///----------------------------------

/**
 Starts the generation of updates that report the user’s current location.
 @discussion This method returns immediately. Calling this method causes the location manager to obtain an initial location fix (which may take several seconds) and notify your delegate by calling its `locationManager:didUpdateToLocation:` method.
 */
- (void)startUpdatingLocation;

/**
 Stops the generation of location updates.
 @discussion Call this method whenever your code no longer needs to receive location-related events. Disabling event delivery gives the receiver the option of disabling the appropriate hardware (and thereby saving power) when no clients need location data. You can always restart the generation of location updates by calling the `startUpdatingLocation` method again.
 */
- (void)stopUpdatingLocation;

@end


@protocol PWBeaconProximityManagerDelegate <PWLocationManagerDelegate>

- (void)locationManager:(PWBeaconProximityManager *)manager didUpdateToLocation:(PWIndoorLocation *)location;
- (void)locationManager:(PWBeaconProximityManager *)manager failedWithError:(NSError *)error;

@end