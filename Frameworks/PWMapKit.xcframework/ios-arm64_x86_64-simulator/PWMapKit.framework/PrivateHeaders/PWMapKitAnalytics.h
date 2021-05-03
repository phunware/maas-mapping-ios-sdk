//
//  PWMapKitAnalytics.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWBuilding;

/**
 The `PWMapKitAnalytics` interfaces provides the methods to collect data for analytics that are not automatically captured by the SDK.
 */

@interface PWMapKitAnalytics : NSObject

/**
 Returns a boolean value indicating whether or not mapping analytics has been enabled.
 @discussion Mapping analytics are disabled by default.
 @return A boolean value indicating whether or not mapping analytics has been enabled.
 */
+ (BOOL)analyticsEnabled;

/**
 Enables mapping analytics.
 @discussion If mapping analytics is already enabled this method will have no effect.
 */
+ (void)enableAnalytics;

/**
 Disables mapping analytics.
 @discussion If mapping analytics is already disabled this method will have no effect.
 */
+ (void)disableAnalytics;


/**
 Send the analytics data for point-of-interest search text.
 @param text The search text.
 @param building The building associated with the point-of-interest search text.
 @discussion You should use this method when the user is searching for points of interest. It's recommended that you only send search text after the user has finished typing.
 */
+ (void)sendPointOfInterestSearchText:(NSString *)text withBuilding:(PWBuilding *)building;

@end
