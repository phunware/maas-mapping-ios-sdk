//
//  PWRouteManeuverOverlay.h
//  PWMapKit
//
//  Created by Sam Odom on 4/14/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

@class PWRouteManeuver;

@interface PWRouteManeuverOverlay : NSObject <MKOverlay>

/**
  The current route maneuver to display.  This value is nil by default.
 */
@property PWRouteManeuver *maneuver;

@end
