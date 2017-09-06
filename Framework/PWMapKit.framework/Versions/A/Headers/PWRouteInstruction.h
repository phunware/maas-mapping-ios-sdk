//
//  PWRouteInstruction.h
//  PWMapKit
//
//  Copyright (c) 2017 Phunware. All rights reserved.
//

@class PWRoute;
@class PWPointOfInterest;

static NSString *const kPWRouteInstructionDirectionSharpLeft = @"PWRouteInstructionDirectionSharpLeft";
static NSString *const kPWRouteInstructionDirectionSharpRight = @"PWRouteInstructionDirectionSharpRight";
static NSString *const kPWRouteInstructionDirectionStraight = @"PWRouteInstructionDirectionStraight";
static NSString *const kPWRouteInstructionDirectionBearLeft = @"PWRouteInstructionDirectionBearLeft";
static NSString *const kPWRouteInstructionDirectionBearRight = @"PWRouteInstructionDirectionBearRight";
static NSString *const kPWRouteInstructionDirectionElevatorUp = @"PWRouteInstructionDirectionElevatorUp";
static NSString *const kPWRouteInstructionDirectionElevatorDown = @"PWRouteInstructionDirectionElevatorDown";
static NSString *const kPWRouteInstructionDirectionStairsUp = @"PWRouteInstructionDirectionStairsUp";
static NSString *const kPWRouteInstructionDirectionStairsDown = @"PWRouteInstructionDirectionStairsDown";
static NSString *const kPWRouteInstructionDirectionEscalatorUp = @"PWRouteInstructionDirectionEscalatorUp";
static NSString *const kPWRouteInstructionDirectionEscalatorDown = @"PWRouteInstructionDirectionEscalatorDown";

typedef NS_ENUM(NSUInteger, PWRouteInstructionDirection) {
    /** Indicates a straight route instruction */
    PWRouteInstructionDirectionStraight,
    /** Indicates a left-turn route instruction */
    PWRouteInstructionDirectionLeft,
    /** Indicates a right route instruction */
    PWRouteInstructionDirectionRight,
    /** Indicates a a bear left route instruction */
    PWRouteInstructionDirectionBearLeft,
    /** Indicates a bear left route instruction */
    PWRouteInstructionDirectionBearRight,
    /** Indicates a floor change route instruction */
    PWRouteInstructionDirectionFloorChange,
    /** Indicates a elevator up */
    PWRouteInstructionDirectionElevatorUp,
    /** Indicates a elevator down */
    PWRouteInstructionDirectionElevatorDown,
    /** Indicates a stairs up */
    PWRouteInstructionDirectionStairsUp,
    /** Indicates a stairs down */
    PWRouteInstructionDirectionStairsDown,
    /** Indicates a escalator up */
    PWRouteInstructionDirectionEscalatorUp,
    /** Indicates a escalator down */
    PWRouteInstructionDirectionEscalatorDown
};

/**
 A `PWRouteInstruction` class represents one step inside a route with the necessary moves to go from the start point and the end point.
 */

@interface PWRouteInstruction : NSObject

# pragma mark - Summary

/**
 * A reference to the `PWRoute` object.
 */
@property (readonly, nonatomic, weak) PWRoute *route;

/**
 * The total distance of the route expressed in meters.
 */
@property (readonly, nonatomic) CLLocationDistance distance;

/**
 * The sequence of points represented by this maneuver.
 */
@property (readonly, nonatomic) NSArray /* PWMapPoint */ *points;

/**
 Polyline representing the sequence of points to be drawn for this instruction.
 */
@property (readonly, nonatomic) MKPolyline *polyline;

/**
 A flag check if it's last route instruction in the associated route.
 */
@property (nonatomic, readonly, getter=isLast) BOOL last;

# pragma mark - Current Instruction Properties

/**
 * The text of representing the movement instruction for the current instruction instance.
 */
@property (readonly, nonatomic) NSString *movement;

/**
 * The direction of the movement for the current instruction instance. Possible values are defined on the PWRouteInstructionDirection ENUM constant.
 */
@property (readonly, nonatomic) PWRouteInstructionDirection movementDirection;

/**
 * The heading of the movement relative to true north. Expressed as an angle in degrees between 0 and 360.
 */
@property (readonly, nonatomic) CLLocationDirection movementTrueHeading;

# pragma mark - Turn(to Next) Instruction Properties

/**
 * A NSString object representing the turn instruction for the current instruction instance.
 * @discussion Replace with `movement`.
 */
@property (readonly, nonatomic) NSString *turn;

/**
 * A NSUInteger value expressing the direction of the turn for the current instruction instance. Possible values are defined on the PWRouteInstructionDirection ENUM constant.
 * @discussion Replace with `movementDirection`.
 */
@property (readonly, nonatomic) PWRouteInstructionDirection turnDirection;

/**
 * The angle of the turn expressed as an angle in degrees between -180 and 180. Returns 0 if the instruction has no turn.
 */
@property (readonly, nonatomic) CLLocationDirection turnAngle;

# pragma mark - Deprecated Properties

/**
 * A reference to the origin, or start point-of-interest, for the route. It may be nil when it's a way point instead of point-of-interest.
 * @discussion Replace with points.firstObject.
 */
@property (readonly, nonatomic) PWPointOfInterest *startPointOfInterest __deprecated;

/**
 * A reference to the destination, or end point-of-interest, for the route. It may be nil when it's a way point instead of point-of-interest.
 * @discussion Replace with points.lastObject.
 */
@property (readonly, nonatomic) PWPointOfInterest *endPointOfInterest __deprecated;

@end
