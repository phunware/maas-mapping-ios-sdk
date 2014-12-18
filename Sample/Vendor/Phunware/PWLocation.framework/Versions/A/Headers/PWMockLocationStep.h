//
//  PWMockLocationStep.h
//  PWLocation
//
//  Copyright (c) 2014 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWIndoorLocation;

/**
 A `PWMockLocationStep` object represents a discreet mock location step, which includes the `PWIndoorLocation` and an `updateInterval` property. Typically, you won't initialize this class directly.
 
 This class is designed to be used as is and should not be subclassed.
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

+ (PWMockLocationStep *)unpack:(NSDictionary *)dictionary;

@end
