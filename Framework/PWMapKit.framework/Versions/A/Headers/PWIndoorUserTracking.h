//
//  PWIndoorUserTracking.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#ifndef PWMapKit_PWIndoorUserTracking_h
#define PWMapKit_PWIndoorUserTracking_h

/**
 `PWIndoorUserTrackingMode` is used to indicate how to track the user's indoor location on a map.
 */
typedef NS_ENUM(NSUInteger, PWIndoorUserTrackingMode) {
    PWIndoorUserTrackingModeNone,
    PWIndoorUserTrackingModeFollow,
    PWIndoorUserTrackingModeFollowWithHeading
};

#endif
