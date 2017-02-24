//
//  RouteAccessibilityManager.h
//  Maps-Samples
//
//  Created on 9/26/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonSettings.h"

typedef NS_ENUM(NSUInteger, LocationDistanceUnit) {
    LocationDistanceUnitMeter = 0,
    LocationDistanceUnitFeet
};

typedef NS_ENUM(NSUInteger, DirectionType) {
    DirectionTypeDefault = 0,
    DirectionTypeOClock
};

@protocol RouteAccessibilityManagerDelegate <NSObject>

/**
 Reports to delegate that a route instruction’s accessibility should be reset.
 @param routeInstruction The `PWRouteInstruction` need to be reset.
 @discussion This happens when:
    1. RouteInstruction changed, we need to reset the accessibility label for the previous instruction.
    2. User walks back when it's about to finish current route instruction, we need to reset the accessibility label.
 */
- (void)shouldResetRouteInstruction:(PWRouteInstruction *)routeInstruction;

/**
 Tell just started a new route instruction.
 @param routeInstruction The current `PWRouteInstruction`.
 @param voiceOver An accessibility label describes the started route instruction.
 */
- (void)routeInstruction:(PWRouteInstruction *)routeInstruction didStartRouteInstructionVO:(NSString *)voiceOver;

/**
 Tell it's about to end a route instruction.
 @param routeInstruction The current `PWRouteInstruction`.
 @param voiceOver An accessibility label describes the route instruction will end.
 */
- (void)routeInstruction:(PWRouteInstruction *)routeInstruction willEndRouteInstructionVO:(NSString *)voiceOver;

/**
 Tell user just walked at least 50 foot.
 @param routeInstruction The current `PWRouteInstruction`.
 @param voiceOver An accessibility label to describe the rest of the distance in current route instruction.
 */
- (void)routeInstruction:(PWRouteInstruction *)routeInstruction didLongDistanceMoveVO:(NSString *)voiceOver;

/**
 Tell orientation just changed.
 @param routeInstruction The current `PWRouteInstruction`.
 @param voiceOver An accessibility label to describe current orientation.
 @param rightOrientation Indicates if it's currently on right orientation.
 */
- (void)routeInstruction:(PWRouteInstruction *)routeInstruction didChangeOrientationVO:(NSString *)voiceOver onRightOrientation:(BOOL)rightOrientation;

/**
 Tell arriving destination.
 @param routeInstruction The current `PWRouteInstruction`.
 @param voiceOver An accessibility label to describe arriving destination.
 */
- (void)routeInstruction:(PWRouteInstruction *)routeInstruction arrivingDestination:(NSString *)voiceOver;

@end

@interface RouteAccessibilityManager : NSObject

/**
 The current route instruction.
 */
@property (nonatomic, strong) PWRouteInstruction *currentRouteInstruction;

/**
 The distance unit, which can be meter or feet.
 */
@property (nonatomic) LocationDistanceUnit locationDistanceUnit;

/**
 The direction type.
 */
@property (nonatomic) DirectionType directionType;

/**
 The delegate used for notifying route instruction changes.
 */
@property (nonatomic, weak) id<RouteAccessibilityManagerDelegate> delegate;

/**
 A shared instance of `RouteAccessibilityManager`.
 */
+ (RouteAccessibilityManager *)sharedInstance;


/**
 Generate the word to describe a distance.
 @param angle The distance scale in meter.
 */
- (NSString *)distanceFormat:(CLLocationDistance)meter;

/**
 Generate the word to describe the direction.
 @param direction The location direction.
 */
- (NSString *)orientationFormat:(CLLocationDirection)direction;

/**
 Convert from a angle orientation to clock orientation.
 @param angle The angle need to convert.
 */
- (NSNumber *)clockDirectionFromAngle:(float)angle;

@end
