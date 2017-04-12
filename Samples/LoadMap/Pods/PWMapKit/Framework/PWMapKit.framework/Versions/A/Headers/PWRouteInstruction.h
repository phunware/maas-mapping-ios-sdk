//
//  PWRouteInstruction.h
//  PWMapKit
//
//  Created by Steven Spry on 5/19/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "PWRoute.h"

static NSString *const kPWRouteInstructionDirectionSharpLeft = @"PWRouteInstructionDirectionSharpLeft";
static NSString *const kPWRouteInstructionDirectionSharpRight = @"PWRouteInstructionDirectionSharpRight";
static NSString *const kPWRouteInstructionDirectionStraight = @"PWRouteInstructionDirectionStraight";
static NSString *const kPWRouteInstructionDirectionBearLeft = @"PWRouteInstructionDirectionBearLeft";
static NSString *const kPWRouteInstructionDirectionBearRight = @"PWRouteInstructionDirectionBearRight";
static NSString *const kPWRouteInstructionDirectionElevatorUp = @"PWRouteInstructionDirectionElevatorUp";
static NSString *const kPWRouteInstructionDirectionElevatorDown = @"PWRouteInstructionDirectionElevatorDown";
static NSString *const kPWRouteInstructionDirectionStairsUp = @"PWRouteInstructionDirectionStairsUp";
static NSString *const kPWRouteInstructionDirectionStairsDown = @"PWRouteInstructionDirectionStairsDown";

/**
 *  Defines the different types of custom locations.
 */
typedef NS_ENUM(NSUInteger, PWRouteInstructionDirection) {
    /**
     *  Route instruction direction straight.
     */
    PWRouteInstructionDirectionStraight,
    /**
     *  Route instruction direction left.
     */
    PWRouteInstructionDirectionLeft,
    /**
     *  Route instruction direction right.
     */
    PWRouteInstructionDirectionRight,
    /**
     *  Route instruction direction bear left.
     */
    PWRouteInstructionDirectionBearLeft,
    /**
     *  Route instruction direction bear right.
     */
    PWRouteInstructionDirectionBearRight,
    /**
     *  Route instruction direction floor change.
     */
    PWRouteInstructionDirectionFloorChange,
    /**
     *  Route instruction direction elevator up.
     */
    PWRouteInstructionDirectionElevatorUp,
    /**
     *  Route instruction direction elevator down.
     */
    PWRouteInstructionDirectionElevatorDown,
    /**
     *  Route instruction direction stairs up.
     */
    PWRouteInstructionDirectionStairsUp,
    /**
     *  Route instruction direction stairs down.
     */
    PWRouteInstructionDirectionStairsDown
};

/**
 *  PWRouteInstruction class represents one step inside a route with the necessary moves to go from the start point of interest and the end point of interest.
 */
@interface PWRouteInstruction : NSObject

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 * Sequence of points represented by this maneuver.
 */
@property (readonly, copy) NSArray /* PWMapPoint */ *points;

/**
 *  A reference to the origin, or start point of interest, for the route.
 * @discussion Change to use points.firstObject
 */
@property (nonatomic,readonly) PWPointOfInterest *startPointOfInterest __deprecated;

/**
 *  A reference to the destination, or end point of interest, for the route.
 * @discussion Change to use points.lastObject
 */
@property (nonatomic,readonly) PWPointOfInterest *endPointOfInterest __deprecated;

/**
 *  A reference to the route object the route instruction instance belongs to.
 */
@property (nonatomic,readonly) PWRoute *route;

/**
 *  A NSString object representing the movement instruction for the current instruction instance.
 */
@property (nonatomic,copy,readonly) NSString *movement;

/**
 *  A NSUInteger value expressing the direction of the movement for the current instruction instance. Possible values are defined on the PWRouteInstructionDirection ENUM constant.
 */
@property (nonatomic,readonly) PWRouteInstructionDirection movementDirection;

/**
 *  The heading of the movement relative to true north. Expressed as an angle in degrees between 0 and 360.
 */
@property (nonatomic, readonly) CLLocationDirection movementTrueHeading;

/**
 *  A NSString object representing the turn instruction for the current instruction instance.
 */
@property (nonatomic,copy,readonly) NSString *turn;

/**
 *  A NSUInteger value expressing the direction of the turn for the current instruction instance. Possible values are defined on the PWRouteInstructionDirection ENUM constant.
 */
@property (nonatomic,readonly) PWRouteInstructionDirection turnDirection;

/**
 *  The angle of the turn expressed as an angle in degrees between -180 and 180. Returns 0 if the instruction has no turn.
 */
@property (nonatomic, readonly) float turnAngle;

/**
 *  A CLLocationDistance property representing the total distance of the route expressed in meters.
 */
@property (nonatomic,readonly) CLLocationDistance distance;

@end
