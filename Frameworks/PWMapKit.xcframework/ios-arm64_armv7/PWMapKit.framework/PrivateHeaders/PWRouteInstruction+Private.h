//
//  PWRouteInstruction.h
//  PWMapKit
//
//  Created by Sam Odom on 4/1/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>

#import "PWMapPoint.h"
#import "PWBuilding+Private.h"
#import "PWBuilding+Private.h"

@class PWUserLocation;

@interface PWRouteInstruction ()

/**
 Index to represent this instruction's relative position in the containing route.
 */
@property (nonatomic) NSUInteger index;

/**
 Indicates whether this instruction is a portal instruction.
 */
@property (nonatomic) BOOL isPortal;

/**
 Indicates whether this instruction is a left- or right-turn instruction.
 */
@property (nonatomic) BOOL isTurn;

/**
 route instruction representing the next instruction in the associated route.  This value is always 'nil' for the last instruction in a route.
 */
@property (nonatomic) PWRouteInstruction *next;

/**
 route instruction representing the previous instruction in the associated route.  This value is always 'nil' for the first instruction in a route.
 */
@property (nonatomic) PWRouteInstruction *previous;

@property (nonatomic, weak) PWRoute *route;
@property (nonatomic) NSArray<id<PWMapPoint>> *points;
@property (nonatomic) NSArray<PWLandmark*> *landmarks;
@property (nonatomic) BOOL last;
@property (nonatomic) PWPointOfInterest *startPointOfInterest;
@property (nonatomic) PWPointOfInterest *endPointOfInterest;
@property (nonatomic) CLLocationDirection turnAngle;
@property (nonatomic) NSString *movement;

+ (instancetype)maneuverWithPoints:(NSArray<id<PWMapPoint>> *)points
                         direction:(PWRouteInstructionDirection)direction
                          distance:(CLLocationDistance)distance;

- (CLLocationDistance)shortestDistanceFromLocation:(PWUserLocation *)location;

@end
