//
//  PWMapFloor.h
//  PWMapKit
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWBuildingFloorResource;

/**
 The build floor object encapsulates all data related to that floor.
 */
@interface PWBuildingFloor : NSObject <NSCoding, NSCopying>

/**
 The floor ID denotes the ID for the floor.
 @discussion The floor ID is used throughout the `PWMapKit`. It determines which annotations to display, among other things.
 */
@property (nonatomic, assign) NSUInteger floorID;

/**
 The building ID that the floor belongs to.
 */
@property (nonatomic, assign) NSUInteger buildingID;

/**
 The physical floor level.
 */
@property (nonatomic, assign) NSInteger floorLevel;

/**
 The coordinates space for the building floor.
 @discussion For identical floors the coordinate space will likely be identical but there are many cases where they could be different.
 */
@property (nonatomic, assign) CGSize coordinateSpace;

/**
 The name of the building floor.
 */
@property (nonatomic, strong) NSString *name;

@end
