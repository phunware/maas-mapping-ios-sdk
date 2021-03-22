//
//  PWBuildingFloorReference.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <CoreLocation/CLLocation.h>

/**
 The floor reference object contains reference information about the floor's location in the map coordinate space.
 */

@interface PWBuildingFloorReference: NSObject

/**
 The top-left lat/long coordinate of the building. (read-only)
 */
@property (readonly) CLLocationCoordinate2D topLeft;

/**
  The top-right lat/long coordinate of the building. (read-only)
 */
@property (readonly) CLLocationCoordinate2D topRight;

/**
  The bottom-left lat/long coordinate of the building. (read-only)
 */
@property (readonly) CLLocationCoordinate2D bottomLeft;

/**
  The bottom-right lat/long coordinate of the building. (read-only)
 */
@property (readonly) CLLocationCoordinate2D bottomRight;

/**
  The angle of the building in the lat/long coordinate space. (read-only)
 */
@property (readonly) CGFloat angle;

@end
