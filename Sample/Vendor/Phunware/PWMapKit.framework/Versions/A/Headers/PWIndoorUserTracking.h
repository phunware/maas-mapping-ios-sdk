//
//  PWIndoorUserTracking.h
//  PWMapKit
//
//  Created by Sam Odom on 10/16/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `PWIndoorUserTrackingMode` is used to indicate how to track the user's indoor location on a map.
 */
typedef NS_ENUM(NSInteger, PWIndoorUserTrackingMode) {
    PWIndoorUserTrackingModeUnknown = -1,
    PWIndoorUserTrackingModeNone,
    PWIndoorUserTrackingModeFollow,
    PWIndoorUserTrackingModeFollowWithHeading
};
