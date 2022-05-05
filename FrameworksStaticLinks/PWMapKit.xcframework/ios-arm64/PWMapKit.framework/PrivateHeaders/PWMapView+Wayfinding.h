//
//  PWMapView+Wayfinding.h
//  PWMapKit
//
//  Created by Sam Odom on 2/9/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWMapView+Private.h"

@class PWRouteStep;

@interface PWMapView (Wayfinding)

- (void)plotRoute:(PWRoute *)route;
- (void)removeRouteOverlays;
- (void)removeRouteIntructionOverlaysOnly;
- (void)updateRouteSnappingPolyline;
- (void)processRouteManeuver:(PWRouteInstruction *)maneuver animated:(BOOL)animated;
- (void)updateRouteOverlaysForRenderedFloors;

@end
