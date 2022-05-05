//
//  MKPolyline+Distance.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class PWIndoorLocation;

@interface MKPolyline (Distance)

/**
 Returns the length (in meters) of the entire polyline.
 */
@property (readonly) CLLocationDistance length;

- (CLLocationDistance)shortestDistanceFromCoordinate:(CLLocationCoordinate2D)coordinate;

@end
