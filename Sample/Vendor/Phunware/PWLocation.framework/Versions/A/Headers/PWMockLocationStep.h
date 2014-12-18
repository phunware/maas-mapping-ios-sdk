//
//  PWMockLocationStep.h
//  PWLocation
//
//  Copyright (c) 2014 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWIndoorLocation;

/**
 A `PWMockLocationStep` object represents a discrete mock location step, which includes the `PWIndoorLocation` and an `updateInterval` property. Typically, this class isn't initialize directly.
 
 This class is designed to be used as-is and should not be subclassed.
 */

@interface PWMockLocationStep : NSObject

/**
 A location object with the updated location information. This object conforms to the `PWLocation` protocol.
 */
@property (readonly) PWIndoorLocation *location;

/**
 The update interval for the mock location step.
 */
@property (readonly) NSTimeInterval updateInterval;


/**
 Initializes a `PWMockLocation` step object with the specified dictionary.
 @param dictionary The dictionary which contains the `PWLocationStep` information.
 @return Returns a `PWLocationStep` object.
 */
+ (PWMockLocationStep *)unpack:(NSDictionary *)dictionary;

@end
