//
//  PWMap.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

/**
 The building data encompasses a variety of metadata about the building.
 */

#import <CoreLocation/CLLocation.h>

/**
 The building object encompasses a wide variety of information associated with the building. Information includes but is not limited to floor data, floor resource data, street address and location.
 */

@interface PWBuilding : NSObject <NSSecureCoding, NSCopying>


/**
 The `PWBuildingFloor` objects associated with the building. (read-only)
 */
@property (nonatomic, readonly) NSArray *floors;

/**
 The building identifier. (read-only)
 */
@property (nonatomic, assign) NSUInteger buildingID;

/**
 The campus identifier for the building. (read-only)
 */
@property (nonatomic, assign) NSInteger campusID;

/**
 The venue GUID as specified by the mapping service. (read-only)
 */
@property (nonatomic, strong) NSString *venueGUID;

/**
 The building name. (read-only)
 */
@property (nonatomic, strong) NSString *name;

/**
 The street address of the building. (read-only)
 */
@property (nonatomic, strong) NSString *streetAddress;

/**
 The location of the building in the lat/long coordinate space. This location is usually the center of the building.
 */
@property (nonatomic, assign) CLLocationCoordinate2D location;

@end
