//
//  PWBuildingFloorReference+Private.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWBuildingFloorReference.h"

/**
 The floor reference object contains reference information about the floor's location in the map coordinate space.
 */

@interface PWBuildingFloorReference ()

@property CLLocationCoordinate2D topLeft;
@property CLLocationCoordinate2D topRight;
@property CLLocationCoordinate2D bottomLeft;
@property CLLocationCoordinate2D bottomRight;
@property CGFloat angle;

@end
