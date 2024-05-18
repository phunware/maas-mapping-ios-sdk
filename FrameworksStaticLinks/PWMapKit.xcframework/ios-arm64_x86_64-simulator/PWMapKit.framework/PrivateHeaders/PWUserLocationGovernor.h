//
//  PWUserLocationGovernor.h
//  PWMapKit
//
//  Created by Sam Odom on 1/4/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWUserLocationGovernorDelegateProtocol.h"
#import "PWRouteSnapperDelegateProtocol.h"
#import "PWHeadingManagerDelegateProtocol.h"
#import "PWMapView.h"

@class PWLocationAverager;
@class PWLocationInterpolator;
@class PWRouteSnapper;
@class PWIndoorLocation;
@class PWUserLocation;
@class PWHeadingManager;

@interface PWUserLocationGovernor : NSObject <PWLocationManagerDelegate, PWRouteSnapperDelegateProtocol, PWHeadingManagerDelegateProtocol>

@property (weak) id<PWUserLocationGovernorDelegateProtocol> delegate;

#pragma mark Location Management

@property (readonly) BOOL hasLocationManager;
@property (readonly) PWIndoorLocation *lastReportedLocation;

- (void)registerLocationManager:(id<PWLocationManager>)locationManager;
- (void)unregisterLocationManager;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

#pragma mark Location Averaging

@property BOOL shouldAverageLocation;
@property (readonly) PWLocationAverager *locationAverager;

#pragma mark Location Interpolation

@property BOOL shouldInterpolateLocation;
@property (readonly) PWLocationInterpolator *locationInterpolator;

#pragma mark Route Snapping

@property BOOL shouldSnapToRoute;
@property PWRouteSnapTolerance routeSnappingTolerance;
@property (readonly) PWRouteSnapper *routeSnapper;

- (void)setRouteStepMultiPolyline:(MKMultiPolyline *)multiPolyline;

#pragma mark Heading Management

@property BOOL shouldTrackUserHeading;
@property (readonly) PWHeadingManager *headingManager;


#pragma mark Current User Disposition

@property (readonly) PWIndoorLocation *userLocation;
@property (readonly) CLHeading *userHeading;

#pragma mark - 

- (void)clearLocationData;

@end
