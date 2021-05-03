//
//  PWRoute+Private.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWLocation/PWLocation.h>
#import <PWMapKit/PWMapKit.h>

#import "PWRouteOptions.h"
#import "PWRouteStep+Private.h"
#import "PWRouteInstruction+Private.h"
#import "PWUserLocation.h"
#import "PWMapKitDefines.h"

@interface PWRoute ()

@property (nonatomic) NSArray /* PWRouteStep* */ *steps;
@property (nonatomic) NSArray /* PWRouteInstruction* */ *maneuvers;
@property (nonatomic) NSArray /* PWRouteInstruction* */ *routeInstructions;
@property (nonatomic) BOOL accessible;
@property (nonatomic) PWBuilding *building;
@property (nonatomic) PWCampus *campus;
@property (nonatomic) id<PWMapPoint> startPoint;
@property (nonatomic) id<PWMapPoint> endPoint;
@property (nonatomic) PWPointOfInterest *startPointOfInterest;
@property (nonatomic) PWPointOfInterest *endPointOfInterest;

- (NSArray *)stepsForFloorID:(NSInteger)floorID;
- (PWRouteStep*)nearestStepToLocation:(PWUserLocation *)location;
- (PWRouteInstruction*)nearestInstructionToLocation:(PWUserLocation *)location;
- (PWRouteInstruction*)firstManeuverForStep:(PWRouteStep *)step;
- (PWRouteStep*)stepForManeuver:(PWRouteInstruction *)maneuver;
- (NSError *)validate;

@end
