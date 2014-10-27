//
//  PWBuilding.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

/**
 The building data encompasses a variety of metadata about the building.
 */

#import <CoreLocation/CLLocation.h>

#import "PWIdentifierTypes.h"

/**
 The building object encompasses a wide variety of information associated with the building. Information includes but is not limited to floor data, floor resource data, street address and location.
 */

@interface PWBuilding : NSObject

/**
 The venue GUID as specified by the mapping service. (read-only)
 */
@property (copy, readonly) NSString *venueGUID;

/**
 The campus identifier for the building. (read-only)
 */
@property (readonly) PWCampusIdentifier campusID;

/**
 The building identifier. (read-only)
 */
@property (readonly) PWBuildingIdentifier buildingID;

/**
 The building name. (read-only)
 */
@property (copy, readonly) NSString *name;

/**
 The street address of the building. (read-only)
 */
@property (copy, readonly) NSString *streetAddress;

/**
 The location of the building in the lat/long coordinate space. This location is usually the center of the building. (read-only)
 */
@property (readonly) CLLocationCoordinate2D location;

/**
 The `PWBuildingFloor` objects associated with the building. (read-only)
 */
@property (readonly) NSArray *floors;


@end
