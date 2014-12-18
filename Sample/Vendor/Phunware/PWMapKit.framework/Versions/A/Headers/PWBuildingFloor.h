//
//  PWMapFloor.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

@class PWBuildingFloorResource, PWBuildingFloorReference;

/**
 The build floor object encapsulates all data related to that floor.
 */
@interface PWBuildingFloor : NSObject <NSSecureCoding, NSCopying>

/**
 The floor identifier denotes the identifier for the floor.
 @discussion The floor identifier is used throughout the `PWMapKit`. It determines which annotations to display, among other things.
 */
@property (nonatomic, assign) NSUInteger floorID;

/**
 The building identifier denotes the building that the floor belongs to.
 */
@property (nonatomic, assign) NSUInteger buildingID;

/**
 The physical floor level.
 */
@property (nonatomic, assign) NSInteger floorLevel;

/**
 The reference GPS points and angle for the building floor.
 */
@property (nonatomic, strong) PWBuildingFloorReference *reference;

/**
 The name of the building's floor.
 */
@property (nonatomic, strong) NSString *name;

@end
