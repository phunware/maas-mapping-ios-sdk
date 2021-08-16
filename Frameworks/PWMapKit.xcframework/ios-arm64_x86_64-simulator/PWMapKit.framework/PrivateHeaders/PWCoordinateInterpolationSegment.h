//
//  PWCoordinateInterpolationSegment.h
//  PWMapKit
//
//  Created by Sam Odom on 1/2/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface PWCoordinateInterpolationSegment: NSObject

@property (readonly) CLLocationCoordinate2D startCoordinate;
@property (readonly) CLLocationCoordinate2D endCoordinate;
@property (readonly) CLLocationAccuracy horizontalAccuracy;
@property (readonly) NSTimeInterval startTimestamp;
@property (readonly) NSTimeInterval endTimestamp;

@property (readonly) CLLocationCoordinate2D interpolatedCoordinate;
@property (readonly) BOOL isExpired;

- (instancetype)initWithStartCoordinate:(CLLocationCoordinate2D)startCoordinate
                          endCoordinate:(CLLocationCoordinate2D)endCoordinate
                     horizontalAccuracy:(CLLocationAccuracy)horizontalAccuracy
                         startTimestamp:(NSTimeInterval)startTimestamp
                           endTimestamp:(NSTimeInterval)endTimestamp;

@end
