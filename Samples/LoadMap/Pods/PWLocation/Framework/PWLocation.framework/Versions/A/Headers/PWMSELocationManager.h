//
//  PWMSELocationManager.h
//  PWLocation
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWLocation/PWIndoorLocation.h>
#import <PWLocation/PWLocationManager.h>

extern NSTimeInterval const PWMSELocationManagerDefaultUpdateInterval;

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
 The floor ID mapping dictionary used to define the mapping between the location provider floor ID and the Phunware floor ID. The dictionary format must adhere to the following format: `@{CUSTOMER_FLOORID : PHUNWARE_FLOOR_ID}`.
 */
@property (nonatomic, strong) NSDictionary *floorIDMapping;

/**
 The interval seconds between location update retrieval.
 @discussion The default value of this property is 2 seconds.
 */
@property (nonatomic, assign) NSTimeInterval updateInterval;

/**
 The default horizontal accuracy radius to be used if none is present.
 @discussion The radius of uncertainty for the location, in meters.
 */
@property (nonatomic, assign) CLLocationDistance defaultHorizontalAccuracy;

/**
 The latest indoor location received from the Phunware location service.
 */
@property (nonatomic, readonly) PWIndoorLocation *location;

/**
 Initializes the location manager with the specified venue GUID and venue location.
 @param venueGUID - The venue GUID is the specific venue identifier for a given indoor location.
 @param venueLocation - The location of the venue.
 @discussion The venue GUID will come from Phunware and is available in the `PWBuilding` object. If the device is not within 5 kilometers of the venue location, location updates will fail.
 @return The location manager object.
 */
- (instancetype)initWithVenueGUID:(NSString *)venueGUID location:(CLLocationCoordinate2D)venueLocation __attribute__((deprecated));

/**
 Initializes the location manager with the specified venue GUID.
 @param venueGUID - The venue GUID is the specific venue identifier for a given indoor location.
 @discussion The venue GUID will come from Phunware and is available in the `PWBuilding` object.
 @return The location manager object.
 */
- (instancetype)initWithVenueGUID:(NSString *)venueGUID NS_DESIGNATED_INITIALIZER;

- (BOOL)locationServicesAvailable;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end

/**
 The `PWMSELocationManagerDelegate` protocol defines the methods used to receive location updates from a `PWMSELocationManager` object. This class conforms to the `PWLocationManagerDelegate` protocol.
 
 The methods of your delegate object are called from the main application thread.
 */

@protocol PWMSELocationManagerDelegate <PWLocationManagerDelegate>

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
- (void)locationManager:(PWMSELocationManager *)manager failedWithError:(NSError *)error;

@end 
