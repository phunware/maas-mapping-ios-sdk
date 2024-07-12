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

NS_ASSUME_NONNULL_BEGIN

/**
 * The `PWRouteInstructionDirection` defines the directions of route.
 */
typedef NS_CLOSED_ENUM(NSUInteger, PWRouteInstructionDirection) {
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
    PWRouteInstructionDirectionFloorChange
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
@property (readonly, nonatomic, nullable) NSArray<PWLandmark *> *landmarks;

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

# pragma mark - Turn (to Next) Instruction Properties

/**
 * An NSUInteger value expressing the direction of the turn for the current instruction instance. Possible values are defined on the `PWRouteInstructionDirection` ENUM constant.
 */
@property (readonly, nonatomic) PWRouteInstructionDirection turnDirection;

/**
 * The angle of the turn expressed as an angle in degrees between -180 and 180. Returns 0 if the instruction has no turn.
 */
@property (readonly, nonatomic) CLLocationDirection turnAngle;

@end

NS_ASSUME_NONNULL_END
