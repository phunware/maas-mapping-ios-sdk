//
//  PWRouteManeuverOverlay.h
//  PWMapKit
//
//  Created by Sam Odom on 4/14/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

@class PWRouteManeuver;

/**
 The `PWRouteManeuverOverlay` defines the basic properties for all route maneuvers. This class should not be subclassed and can be used as is. Instances of this class must have a reference to a valid `PWRouteManeuver` object.
 */

@interface PWRouteManeuverOverlay : NSObject <MKOverlay>

/**
  The current route maneuver to display.  This value is nil by default.
 */
@property PWRouteManeuver *maneuver;

@end
