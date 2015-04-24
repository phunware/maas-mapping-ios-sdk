//
//  PWMockLocationManagerConfiguration.h
//  PWLocation
//
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The `PWMockLocationManagerConfiguration` class is used for parsing mock location data from JSON that can be used by the mock location manager. This object also has several configuration options.
 
 This class conforms to the `PWLocationManager` protocol.
 */


/**
 The JSON format for configurations should be as follows:
 
 {
     "name" : "Bistro to Elevator",          <!-- Location update interval -->
     "description" : "Normal route...",      <!-- Location update interval -->
     "updateInterval" : 2.0,                 <!-- Location update interval -->
     "locations": [
         {
             "latitude": 30.360012,          <!-- Mock latitude -->
             "longitude": -97.74255,         <!-- Mock longitude -->
             "horizontalAccuracy": 5.152377, <!-- Mock accuracy -->
             "floorID": 2,                   <!-- Mock floor ID -->
             "updateInterval": 1.2           <!-- Mock update interval -->
         },
    ...
     ]
 }
 
 */


@interface PWMockLocationManagerConfiguration : NSObject

/**
 The name of the configuration
 */
@property (readonly) NSString *name;

/**
 The description of the configuration.
 */
@property (readonly) NSString *configurationDescription;

/**
 An array of `PWMockLocationStep` objects.
 */
@property (readonly) NSArray *locations;

/**
 The default location update interval.
 */
@property (readonly) NSTimeInterval defaultUpdateInterval;

/**
 A `BOOL` value that determines whether location manager restarts the location updates after all location updates in the scene have played.
 */
@property (readonly) BOOL repeats;

/**
 This method unpacks a configuration from a dictionary.
 @param dictionary The dictionary that containers the configuration information.
 */
+ (instancetype)unpack:(NSDictionary *)dictionary;

@end
