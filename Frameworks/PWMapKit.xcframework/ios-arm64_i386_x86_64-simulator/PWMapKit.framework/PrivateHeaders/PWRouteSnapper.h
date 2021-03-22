//
//  PWRouteSnapper.h
//  PWMapKit
//
//  Created by Sam Odom on 1/4/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWRouteSnapperDelegateProtocol.h"
#import "PWMapView.h"

@interface PWRouteSnapper : NSObject

@property PWRouteSnapTolerance tolerance;
@property float toleranceFactor;
@property MKPolyline *routePolyline;
@property (weak) id<PWRouteSnapperDelegateProtocol> delegate;
@property (getter=isSnapping) BOOL snapping;

- (CLLocationCoordinate2D)snappedCoordinateForCoordinate:(CLLocationCoordinate2D)coordinate withHorizontalAccuracy:(CLLocationAccuracy)accuracy;

@end
