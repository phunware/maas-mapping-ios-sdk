//
//  PWMapView+MapViewDelegation.h
//  PWMapKit
//
//  Created by Sam Odom on 2/9/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWMapView+Private.h"

extern CGFloat SMALLEST_SCREEN_DIMENSION_POINTS;

@interface PWMapView (MapViewDelegation)

- (void)announceWillStartLocatingIndoorUser;
- (void)announceDidStopLocatingIndoorUser;
- (void)announceDidChangeIndoorUserTrackingMode:(PWTrackingMode)mode;
- (void)announceDidUpdateIndoorUserLocation:(PWUserLocation*)location locationManager:(id<PWLocationManager>)locationManager;
- (void)announceDidFailToLocateIndoorUser:(NSError*)error;
- (void)announceDidUpdateHeading:(CLHeading*)heading;
- (void)announceDidStartSnappingToRoute;
- (void)announceDidStopSnappingToRoute;
- (void)announcedidChangeRouteInstruction:(PWRouteInstruction*)maneuver;

- (void)setSmallestScreenDimensionInPoints;
- (void)breakTrackingModeIfNeeded;
- (BOOL)shouldEnableFollowModeImmediately:(BOOL)immediately andBlueDotHasToBeVisible:(BOOL)hasToBeVisible;

@end
