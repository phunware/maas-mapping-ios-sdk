//
//  PWRouteManeuverDirection.h
//  PWMapKit
//
//  Created by Sam Odom on 4/1/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#ifndef PWMapKit_PWRouteManeuverDirection_h
#define PWMapKit_PWRouteManeuverDirection_h

/**
  Enumerated type representing relative directions for turn-by-turn routing maneuvers.
 */
typedef NS_ENUM(NSUInteger, PWRouteManeuverDirection) {
    /** Indicates a straight maneuver */
    PWRouteManeuverDirectionStraight,
    /** Indicates a left-turn maneuver */
    PWRouteManeuverDirectionLeft,
    /** Indicates a right maneuver */
    PWRouteManeuverDirectionRight,
    /** Indicates a a bear left maneuver */
    PWRouteManeuverDirectionBearLeft,
    /** Indicates a bear left maneuver */
    PWRouteManeuverDirectionBearRight,
    /** Indicates a floor change maneuver */
    PWRouteManeuverDirectionFloorChange
};

#endif
