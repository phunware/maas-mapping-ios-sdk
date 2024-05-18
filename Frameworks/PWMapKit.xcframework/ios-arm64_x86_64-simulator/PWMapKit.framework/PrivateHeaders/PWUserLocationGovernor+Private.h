//
//  PWUserLocationGovernor+Private.h
//  PWMapKit
//
//  Created by Sam Odom on 1/4/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <PWLocation/PWLocationManager.h>

#import "PWUserLocationGovernor.h"

@interface PWUserLocationGovernor ()

@property id<PWLocationManager> lastLocationManager;
@property id<PWLocationManager> locationManager;
@property PWIndoorLocation *lastReportedLocation;
@property PWLocationAverager *locationAverager;
@property PWLocationInterpolator *locationInterpolator;
@property PWRouteSnapper *routeSnapper;
@property PWHeadingManager *headingManager;
@property BOOL inFloorTransitionMode;

@end
