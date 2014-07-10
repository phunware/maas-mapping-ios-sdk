//
//  PWMSELocationManager.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWMapKit/PWLocationManager.h>

@class PWLocation;

@protocol PWMSELocationManagerDelegate;

/**
 The `PWMSELocationManager` class defines the interface for configuring the delivery of Cisco Mobility Services Engine (MSE) location-related events to your application. You use an instance of this class to establish the parameters that determine when location events should be delivered and to start and stop the actual delivery of those events. This class conforms to the `PWLocationManager` protocol.
 */

@interface PWMSELocationManager : NSObject <PWLocationManager>

/**
 The venue GUID associated with the location manager. (read-only)
 */
@property (nonatomic, readonly) NSString *venueGUID;

/**
 The venue location associated with the location manager. (read-only)
 */
@property (nonatomic, readonly) CLLocationCoordinate2D venueLocation;

/**
 Initializes the location manager with the specified venue GUID and the venue location.
 @param venueGUID The venue GUID is the specific venue identifier for a given indoor location.
 @param venueLocation The location of the venue.
 @discussion The venue GUID will come from Phunware and is available in the `PWBuilding` object. If the device is not within 5 kilometers of the venue location, then location updates will fail.
 @return The location manager object.
 */
- (instancetype)initWithVenueGUID:(NSString *)venueGUID location:(CLLocationCoordinate2D)venueLocation;

///-------------------------------------------
/// @name Determining Availability of Services
///-------------------------------------------

/**
 Returns a Boolean value indicating whether location services are enabled on the device.
 @discussion In order to fetch the user's location, the manager must be within proximity of the venue and have retrieved specific device information from Phunware's servers.
 */
+ (BOOL)locationServicesEnabled;

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
 @discussion Call this method whenever your code no longer needs to receive Cisco MSE location-related events. Disabling event delivery gives the receiver the option of disabling the appropriate hardware (and thereby saving power) when no clients need location data. You can always restart the generation of location updates by calling the `startUpdatingLocation` method again.
 */
- (void)stopUpdatingLocation;

/**
 Returns a Boolean value that indicates whether the location manager is requesting updates to the user's location.
 */
- (BOOL)updating;

@end

/**
 The `PWMSELocationManagerDelegate` protocol defines the methods used to receive location updates from a `PWMSELocationManager` object. This class conforms to the `PWLocationManagerDelegate` protocol.
 
 The methods of your delegate object are called from the main application thread.
 */

@protocol PWMSELocationManagerDelegate <PWLocationManagerDelegate>

/**
 Tells the delegate that a new location update is available.
 @param manager The location manager object that generated the update event.
 @param location A `PWLocation` object with the updated location information.
 @discussion Implementation of this method is optional but recommended.
 */
- (void)locationManager:(id<PWLocationManager>)manager didUpdateToLocation:(PWLocation *)location;

/**
 Tells the delegate that the location manager was unable to retrieve a location value.
 @param manager The location manager object that was unable to retrieve the location.
 @param error The error object containing the reason the location could not be retrieved.
 @discussion Implementation of this method is optional but recommended.
 
 The location manager calls this method when it encounters an error trying to get the location data. If an error is encountered, the location manager will keep attempting to update until `stopUpdatingLocation` is called.
 */
- (void)locationManager:(id<PWLocationManager>)manager failedWithError:(NSError *)error;

@end 
