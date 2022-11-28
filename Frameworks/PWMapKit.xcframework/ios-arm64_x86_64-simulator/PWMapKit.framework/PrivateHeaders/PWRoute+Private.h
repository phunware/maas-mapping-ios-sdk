//
//  PWRoute+Private.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWLocation/PWLocation.h>
#import <PWMapKit/PWMapKit.h>

#import "PWRouteStep.h"

@interface PWRoute ()

@property (nonatomic) NSArray<PWRouteStep *> *steps;
@property (nonatomic) NSArray<PWRouteInstruction *> *maneuvers;
@property (nonatomic) NSArray<PWRouteInstruction *> *routeInstructions;
@property (nonatomic) BOOL accessible;
@property (nonatomic) PWBuilding *building;
@property (nonatomic) PWCampus *campus;
@property (nonatomic) id<PWMapPoint> startPoint;
@property (nonatomic) id<PWMapPoint> endPoint;
@property (nonatomic) PWPointOfInterest *startPointOfInterest;
@property (nonatomic) PWPointOfInterest *endPointOfInterest;

- (NSArray *)stepsForFloorID:(NSInteger)floorID;
- (PWRouteStep*)nearestStepToLocation:(id<PWMapPoint>)location;
- (PWRouteInstruction*)nearestInstructionToLocation:(id<PWMapPoint>)location;
- (PWRouteInstruction*)firstManeuverForStep:(PWRouteStep *)step;
- (PWRouteStep*)stepForManeuver:(PWRouteInstruction *)maneuver;
- (NSError *)validate;

@end
