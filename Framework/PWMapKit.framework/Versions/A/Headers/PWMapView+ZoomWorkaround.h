//
//  PWMapView+ZoomWorkaround.h
//  PWMapKit
//
//  Created by Sam Odom on 11/3/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWMapView.h"

@interface PWMapView (ZoomWorkaround)

@property (readonly) BOOL isUsingZoomWorkaround;

- (CLLocationCoordinate2D)zoomWorkaroundCoordinateFromCoordinate:(CLLocationCoordinate2D)coordinate;
- (CLLocationCoordinate2D)coordinateFromZoomWorkaroundCoordinate:(CLLocationCoordinate2D)coordinate;
- (CLLocationCoordinate2D)forcedZoomWorkaroundCoordinateFromCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)toggleZoomWorkaround;

@end
