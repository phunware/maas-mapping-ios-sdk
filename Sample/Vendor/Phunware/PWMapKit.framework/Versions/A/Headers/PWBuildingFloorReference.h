//
//  PWBuildingFloorReference.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

/**
 The floor reference object contains reference information about the floor's location in the map coordinate space.
 */

@interface PWBuildingFloorReference : NSObject <NSCopying, NSSecureCoding>

/**
 The top left lat/long coordinate of the building.
 */
@property (nonatomic, assign) CLLocationCoordinate2D topLeft;

/**
  The top right lat/long coordinate of the building.
 */
@property (nonatomic, assign) CLLocationCoordinate2D topRight;

/**
  The bottom left lat/long coordinate of the building.
 */
@property (nonatomic, assign) CLLocationCoordinate2D bottomLeft;

/**
  The bottom right lat/long coordinate of the building.
 */
@property (nonatomic, assign) CLLocationCoordinate2D bottomRight;

/**
  The angle of the building in the lat/long coordinate space.
 */
@property (nonatomic, assign) CGFloat angle;

@end
