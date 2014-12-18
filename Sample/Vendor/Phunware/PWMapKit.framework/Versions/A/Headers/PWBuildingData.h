//
//  PWMap.h
//  PWMapKit
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The building data encompasses a variety of metadata about the build.
 */

@interface PWBuildingData : NSObject <NSCoding, NSCopying>

/**
 The Building ID.
 */
@property (nonatomic, assign) NSUInteger buildingID;

/**
 The Campus ID for the building.
 */
@property (nonatomic, assign) NSInteger campusID;

/**
 The building map name.
 */
@property (nonatomic, strong) NSString *buildingMapName;

/**
 The street address of the building.
 */
@property (nonatomic, strong) NSString *streetAddress;

@end
