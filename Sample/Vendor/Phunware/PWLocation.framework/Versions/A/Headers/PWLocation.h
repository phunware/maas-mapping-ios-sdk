 //
//  PWLocation.h
//  PWLocation
//
//  Copyright (c) 2014 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PWLocation/PWLocationProtocol.h>
#import <PWLocation/PWIndoorLocation.h>
#import <PWLocation/PWLocationManager.h>
#import <PWLocation/PWMSELocationManager.h>
#import <PWLocation/PWSLLocationManager.h>
#import <PWLocation/PWMockLocationManager.h>

/**
 PWLocation is a location based SDK.
 */

@interface PWLocation : NSObject

///----------------------
/// @name Utility Methods
///----------------------

/**
 Returns the name of the SDK, `PWLocation`.
 */
+ (NSString *)serviceName;

@end
