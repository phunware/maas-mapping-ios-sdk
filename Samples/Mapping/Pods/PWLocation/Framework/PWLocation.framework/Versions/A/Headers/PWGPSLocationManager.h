//
//  PWGPSLocationManager.h
//  PWLocation
//
//  Created by Illya Busigin on 1/7/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import <PWLocation/PWIndoorLocation.h>
#import <PWLocation/PWLocationManager.h>

@protocol PWGPSLocationManagerDelegate;

/**
 The `PWGPSLocationManager` class defines the interface for configuring the delivery of GPS location-related events to your application. You use an instance of this class to establish the parameters that determine when location events should be delivered and to start and stop the actual delivery of those events. This class conforms to the `PWLocationManager` protocol.
 
 @discussion You are still responsible for requesting permission to use location services. In addition the `CLLocationManager` associated with this class is exposed so that it can be configured as desired.
 */

@interface PWGPSLocationManager : NSObject <PWLocationManager>

/**
 The `CLLocationManager` used to deliver indoor GPS location updates. 
 @discussion You are still responsible for requesting permission to use location services. The `CLLocationManagerDelegate` of this instance is owned by the `PWGPSLocationManager` instance.
 */
@property (nonatomic, readonly) CLLocationManager *internalLocationManager;

/**
 The floor ID mapping dictionary used to define the mapping between the location provider floor ID and the Phunware floor ID. The dictionary format must adhere to the following format: `@{CUSTOMER_FLOORID : PHUNWARE_FLOOR_ID}`.
 */
@property (nonatomic, strong) NSDictionary *floorIDMapping;

/**
 The latest indoor location received from the Phunware location service.
 */
@property (nonatomic, readonly) PWIndoorLocation *location;

/**
 Initializes the location manager with the specified `CLLocationManager` instance.
 @param locationManager The location manager to use for GPS positioning. There parameter cannot be `nil`.
 @return A `PWGPSLocationManager` instance.
 */
- (instancetype)initWithCLLocationManager:(CLLocationManager *)locationManager NS_DESIGNATED_INITIALIZER;

- (BOOL)locationServicesAvailable;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end

/**
 The `PWMSELocationManagerDelegate` protocol defines the methods used to receive location updates from a `PWMSELocationManager` object. This class conforms to the `PWLocationManagerDelegate` protocol.
 
 The methods of your delegate object are called from the main application thread.
 */

@protocol PWGPSLocationManagerDelegate <PWLocationManagerDelegate>

/**
 Tells the delegate that a new location update is available.
 @param manager The location manager object that generated the update event.
 @param location A location object with the updated location information. This object conforms to the `PWLocation` protocol.
 @discussion Implementation of this method is optional but recommended.
 */
- (void)locationManager:(PWGPSLocationManager *)manager didUpdateToLocation:(id<PWLocation>)location;

/**
 Tells the delegate that the location manager was unable to retrieve a location value.
 @param manager The location manager object that was unable to retrieve the location.
 @param error The error object containing the reason the location could not be retrieved.
 @discussion Implementation of this method is optional but recommended.
 
 The location manager calls this method when it encounters an error trying to get the location data. If an error is encountered, the location manager will keep attempting to update until `stopUpdatingLocation` is called.
 */
- (void)locationManager:(PWGPSLocationManager *)manager failedWithError:(NSError *)error;

@end
