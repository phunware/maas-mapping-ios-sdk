//
//  PWFloor+Private.h
//  PWMapKit
//
//  Created by Sam Odom on 10/20/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

//
//  PWMapFloor.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>

#import "PWBuilding+Private.h"
#import "PWPointOfInterestType.h"
#import "PWMappingUtilities.h"
#import "PWMapDocument.h"
#import "PWBuildingFloorReference.h"
#import "PWBuildingFloorResource.h"

@interface PWFloor ()

// Building info
@property (nonatomic, weak, nullable) PWBuilding *building;
@property (nonatomic) PWBuildingIdentifier buildingID;
@property (nonatomic, nullable) NSString *name;

// Floor info
@property (nonatomic) NSInteger floorID;
@property (nonatomic) PWBuildingFloorLevel level;
@property (nonatomic, nullable) PWBuildingFloorReference *reference;
@property (nonatomic, nullable) PWBuildingFloorResource *resource;
@property (nonatomic, nullable) PWMapDocument *mapDocument;
@property (nonatomic) BOOL isDefault;

// POIs
@property (nonatomic, nullable) NSArray *pointsOfInterest;

- (nullable NSError *)validate;

@end
