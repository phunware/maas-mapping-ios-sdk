//
//  RouteBuilderHelpers.h
//  PWMapKit
//
//  Created by Sam Odom on 4/21/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#ifndef PWMapKit_RouteBuilderHelpers_h
#define PWMapKit_RouteBuilderHelpers_h

#import "PWMapPoint.h"
#import "PWBuilding.h"
#import "PWRouteInstruction+Private.h"

@class PWRouteInstruction;
@class PWRouteStep;
@protocol PWMapPoint;

CLLocationDirection TurnAngleBetweenPoints(NSArray<id<PWMapPoint>> *);
CLLocationDistance DistanceBetweenPoints(NSArray<id<PWMapPoint>> *points);
NSString* LandmarkNameFromMapPoint(id<PWMapPoint> mapPoint);

BOOL AngleIsBear(CLLocationDirection);
NSRange ExtendRange(NSRange, NSUInteger);
NSRange RangeOfLastTwoInRange(NSRange);
PWRouteInstructionDirection DirectionFromAngle(CLLocationDirection angle);

PWRouteInstruction * MakePortalManeuverBetweenSteps(PWRouteStep*, PWRouteStep*);
PWRouteInstruction * CreateManeuverWithPoints(NSArray<id<PWMapPoint>> *);
PWRouteInstruction * CreateTurnManeuverAtPoint(id<PWMapPoint>, CLLocationDirection);

#endif
