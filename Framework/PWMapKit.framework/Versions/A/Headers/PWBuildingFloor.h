//
//  PWMapFloor.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWMappingTypes.h"

@class PWBuildingFloorReference;

/**
 The building floor object encapsulates all data related to a floor.
 */
@interface PWBuildingFloor : NSObject

/**
 The name of the building's floor.
 */
@property (copy, readonly) NSString *name;

/**
 The building identifier denotes the building that the floor belongs to.
 */
@property (readonly) PWBuildingFloorIdentifier buildingID;

/**
 The floor identifier.
 @discussion The floor identifier is used throughout the `PWMapKit`. It determines which annotations to display, among other things.
 */
@property (readonly) PWBuildingFloorIdentifier floorID;


/**
 The physical floor level.
 */
@property (readonly) PWBuildingFloorLevel floorLevel;

/**
 The reference GPS points and angle for the building's floor.
 */
@property (readonly) PWBuildingFloorReference *reference;

@end
