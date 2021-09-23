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
@property (nonatomic, weak) PWBuilding *building;
@property (nonatomic) PWBuildingIdentifier buildingID;
@property (nonatomic) NSString *name;

// Floor info
@property (nonatomic) NSInteger floorID;
@property (nonatomic) PWBuildingFloorLevel level;
@property (nonatomic) PWBuildingFloorReference *reference;
@property (nonatomic) PWBuildingFloorResource *resource;
@property (nonatomic) PWMapDocument *mapDocument;

// Campus routing info
@property (nonatomic) NSArray<PWFloor *> *connectedFloors;

// POIs
@property (nonatomic) NSArray *pointsOfInterest;

- (NSError *)validate;
- (void)resetConnectedFloors;
- (NSArray *)floorsToRenderForRouting;

@end