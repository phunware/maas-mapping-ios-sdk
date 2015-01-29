//
//  PWLocationManager.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <PWLocation/PWIndoorLocation.h>

@protocol PWLocation;
@protocol PWLocationManagerDelegate;

static const CLLocationDistance kMinimumVenueProximity = 5000;

/**
 `PWLocationManagerError` specifies the location manager's failed error codes.
 */
typedef NS_ENUM(NSUInteger, PWLocationManagerError) {
    /** The error is unknown. */
    PWLocationManagerErrorUnknown= -1,
    /** A bad location request error. */
    PWLocationManagerErrorBadRequest = 400,
    /** Not authorized to fetch location information. */
    PWLocationManagerErrorUnauthorized = 401,
    /** The location request timed out. */
    PWLocationManagerErrorRequestTimeout = 408,
    /** Location services are unavailable. */
    PWLocationManagerErrorServiceUnavailable = 503,
    /** Mock location data is invalid. */
    PWLocationManagerErrorMockDataInvalid = 1000,
    /** Mock location data is invalid. */
    PWLocationManagerErrorUnconfirmLocation = 1001
};

/**
 The `PWLocationManager` protocol defines the methods used to create a location manager. This location manager is typically used with indoor location providers.
 */

@protocol PWLocationManager <NSObject>

/**
 The floor ID mapping dictionary used to define the mapping between the location provider floor ID and the Phunware floor ID. The dictionary format must adhere to the following format: `@{CUSTOMER_FLOORID : PHUNWARE_FLOOR_ID}`.
 */
@property (nonatomic, strong) NSDictionary *floorIDMapping;

/**
 The most recently retrieved indoor location.
 
 @discussion The value of this property is nil if no location data has ever been retrieved.
 */
@property (nonatomic, readonly) PWIndoorLocation *location;

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

/**
 The `PWLocationManagerDelegate` protocol defines the methods used to receive location updates from an object that subscribes to the `PWLocationManager` protocol. 
 
 The methods of your delegate object are always called from the main application thread.
 */

@property (nonatomic, weak) id<PWLocationManagerDelegate> delegate;
    
@end

/**
 The `PWLocationManagerDelegate` protocol defines the methods used to receive location updates from a `PWLocationManager` object.
 
 The methods of your delegate object are called from the main application thread.
 */

@protocol PWLocationManagerDelegate <NSObject>

@optional

/**
 Tells the delegate that a new location update is available.
 @param manager The location manager object that generated the update event.
 @param location A location object with the updated location information. This object conforms to the `PWLocation` protocol.
 @discussion Implementation of this method is optional but recommended.
 */
- (void)locationManager:(id<PWLocationManager>)manager didUpdateToLocation:(id<PWLocation>)location;

/**
 Tells the delegate that the location manager was unable to retrieve a location value.
 @param manager The location manager object that was unable to retrieve the location.
 @param error The error object containing the reason the location could not be retrieved.
 @discussion Implementation of this method is optional but recommended.
 
 The location manager calls this method when it encounters an error trying to get the location data. If an error is encountered, the location manager will keep attempting to update until `stopUpdatingLocation` is called.
 */
- (void)locationManager:(id<PWLocationManager>)manager failedWithError:(NSError *)error;
    
@end

