//
//  PWRouteInstruction.h
//  PWMapKit
//
//  Copyright (c) 2017 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class PWRoute;
@class PWPointOfInterest;
@class PWLandmark;
@protocol PWMapPoint;

// APENDLEY: What are these for? They don't seem to be used by the SDK, and they don't seem useful to customers either.
// TODO: Find out from product team if these are being refrenced by customers, and if not, remove them.
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

/**
 * The `PWRouteInstructionDirection` defines the directions of route.
 */
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
    
    // APENDLEY (10/15/2019): We are deprecating these because this should be left to the customer to determine, as well as to have parity with the Android SDK.
    /** Indicates a elevator up */
    PWRouteInstructionDirectionElevatorUp __deprecated_enum_msg("please use PWRouteInstructionDirectionFloorChange"),
    /** Indicates a elevator down */
    PWRouteInstructionDirectionElevatorDown __deprecated_enum_msg("please use PWRouteInstructionDirectionFloorChange"),
    /** Indicates a stairs up */
    PWRouteInstructionDirectionStairsUp __deprecated_enum_msg("please use PWRouteInstructionDirectionFloorChange"),
    /** Indicates a stairs down */
    PWRouteInstructionDirectionStairsDown __deprecated_enum_msg("please use PWRouteInstructionDirectionFloorChange"),
    /** Indicates a escalator up */
    PWRouteInstructionDirectionEscalatorUp __deprecated_enum_msg("please use PWRouteInstructionDirectionFloorChange"),
    /** Indicates a escalator down */
    PWRouteInstructionDirectionEscalatorDown __deprecated_enum_msg("please use PWRouteInstructionDirectionFloorChange")
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
 * The total distance of the instruction expressed in meters.
 */
@property (readonly, nonatomic) CLLocationDistance distance;

/**
 * The sequence of points represented by this instruction.
 */
@property (readonly, nonatomic) NSArray<id<PWMapPoint>> *points;

/**
 * The first point in this maneuver
 */
@property (nonatomic, readonly, nonnull) id<PWMapPoint> start;

/**
 * The last point in this maneuver
 */
@property (nonatomic, readonly, nonnull) id<PWMapPoint> end;

/**
 Polyline representing the sequence of points to be drawn for this instruction.
 */
@property (readonly, nonatomic) MKPolyline *polyline;

/**
 * Landmarks included in this instruction
 */
@property (readonly, nonatomic, nullable) NSArray<PWLandmark*> *landmarks;

/**
 A flag indicating if it's the last route instruction in the associated route.
 */
@property (nonatomic, readonly, getter=isLast) BOOL last;

# pragma mark - Current Instruction Properties

/**
 * The direction of the movement for the current instruction instance. Possible values are defined on the `PWRouteInstructionDirection` ENUM constant.
 */
@property (readonly, nonatomic) PWRouteInstructionDirection direction;

/**
 * The heading of the movement relative to true north. Expressed as an angle in degrees between 0 and 360.
 */
@property (readonly, nonatomic) CLLocationDirection movementTrueHeading;

# pragma mark - Turn(to Next) Instruction Properties

/**
 * An NSUInteger value expressing the direction of the turn for the current instruction instance. Possible values are defined on the `PWRouteInstructionDirection` ENUM constant.
 */
@property (readonly, nonatomic) PWRouteInstructionDirection turnDirection;

/**
 * The angle of the turn expressed as an angle in degrees between -180 and 180. Returns 0 if the instruction has no turn.
 */
@property (readonly, nonatomic) CLLocationDirection turnAngle;

# pragma mark - Deprecated Properties

/**
 * The direction of the movement for the current instruction instance. Possible values are defined on the `PWRouteInstructionDirection` ENUM constant.
 * @discussion Use 'direction' property instead
 */
@property (readonly, nonatomic) PWRouteInstructionDirection movementDirection __deprecated;

/**
 * The text representing the movement instruction for the current instruction instance.
 */
@property (readonly, nonatomic) NSString *movement __deprecated;

/**
 * An NSString object representing the turn instruction for the current instruction instance.
 */
@property (readonly, nonatomic) NSString *turn __deprecated;

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
