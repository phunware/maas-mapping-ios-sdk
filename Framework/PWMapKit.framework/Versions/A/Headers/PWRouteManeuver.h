//
//  PWRouteManeuver.h
//  PWMapKit
//
//  Created by Sam Odom on 4/1/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWRouteManeuverDirection.h"

@interface PWRouteManeuver : NSObject

/**
  Index to represent this maneuver's relative position in the containing route step.
 */
@property (readonly) NSUInteger index;

/**
  Sequence of points represented by this maneuver.
 */
@property (readonly, copy) NSArray /* PWDirectionsWaypointProtocol */ *points;

/**
  Direction of this maneuver relative to the next maneuver.
 */
@property (readonly) PWRouteManeuverDirection direction;

/**
  The total distance in meters between the first and last points in the maneuver along the connecting segments.
 */
@property (readonly) CLLocationDistance distance;

/**
  Indicates whether this maneuver is a portal maneuver.
 */
@property (readonly) BOOL isPortalManeuver;

/**
 Indicates whether this maneuver is a left- or right-turn maneuver.
 */
@property (readonly) BOOL isTurnManeuver;

/**
  Polyline representing the sequence of points to be drawn for this maneuver.
 */
@property (readonly) MKPolyline *polyline;

/**
  Route maneuver representing the next maneuver in the associated route.  This value is always 'nil' for the last maneuver in a route.
 */
@property (readonly) PWRouteManeuver *nextManeuver;

/**
  Route maneuver representing the previous maneuver in the associated route.  This value is always 'nil' for the first maneuver in a route.
 */
@property (readonly) PWRouteManeuver *previousManeuver;


@end
