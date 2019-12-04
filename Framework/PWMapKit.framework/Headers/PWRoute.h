//
//  PWRoute.h
//  PWMapKit
//
//  Copyright (c) 2017 Phunware. All rights reserved.
//

#import "PWMapPoint.h"

@class PWBuilding;
@class PWPointOfInterest;
@class PWRouteOptions;

/**
 The `PWRoute` class defines a single route that the user can follow between a requested start and end point. The route object defines the geometry for the route and includes route information you can display to the user, such as the name of the route, its distance and the expected travel time.
 
 Do not create instances of this class directly. Instead, use `createRouteFrom: to: options: completion:`.
 */

@interface PWRoute : NSObject

/**
 * A reference to the route's building object.
 */
@property (nonatomic,readonly) PWBuilding *building;

/**
 * A reference to the origin, or start point, for the route.
 */
@property (readonly) id<PWMapPoint> startPoint;

/**
 * A reference to the destination, or end point, for the route.
 */
@property (readonly) id<PWMapPoint> endPoint;

/**
 * A reference to the origin, or start point-of-interest, for the route.
 * @deprecated Use `startPoint` instead, since v3.2.0.
 */
@property (nonatomic,readonly) PWPointOfInterest *startPointOfInterest __deprecated;

/**
 * A reference to the destination, or end point-of-interest, for the route.
 * @deprecated Use `endPoint` instead, since v3.2.0.
 */
@property (nonatomic,readonly) PWPointOfInterest *endPointOfInterest __deprecated;

/**
 * An array of `PWRouteInstruction` objects containing instructions to follow the route path.
 */
@property (nonatomic,readonly) NSArray<PWRouteInstruction *> *routeInstructions;

/**
 * An integer representing the total distance of the route expressed in meters.
 */
@property (nonatomic,readonly) CLLocationDistance distance;

/**
 * An integer representing the estimated time of the route expressed in seconds.
 */
@property (nonatomic,readonly) NSInteger estimatedTime;

/**
 * A BOOL value that returns YES if the route was calculated with accessibility.
 */
@property (nonatomic, readonly, getter=isAccessible) BOOL accessible;

/**
 *  Instantiates a new PWRoute object using the given parameters. Calculates a route to navigate between the start POI and the end POI. The completion handler is called when the route is fully calculated.
 *
 *  @param startPoint    PWPointOfInterest object representing the start point for the route calculation.
 *  @param endPoint      PWPointOfInterest object representing the end point for the route calculation.
 *  @param accessibility BOOL Value to tell the route init if accessibility should be considered to calculate the route.
 *  @param completion    Completion handler that is called once the route's calculation is complete.
 *
 *  @deprecated use 'createRouteFrom:to:options:completion:' instead
 */
+ (void)initRouteFrom:(PWPointOfInterest *)startPoint to:(PWPointOfInterest *)endPoint accessibility:(BOOL)accessibility completion:(void(^)(PWRoute *route, NSError *error))completion __deprecated;

/**
 *  Instantiates a new PWRoute object using the given parameters. Calculates a route to navigate between the start `PWMapPoint` and the end `PWMapPoint`. The completion handler is called when the route is fully calculated.
 *
 *  @param startPoint    A `PWMapPoint` object representing the start point for the route calculation.
 *  @param endPoint      A `PWMapPoint` object representing the end point for the route calculation.
 *  @param accessibility A BOOL value to tell the route builder if accessibility should be considered to calculate the route.
 *  @param excludedPoints An array of `PWMapPoint` objects to be excluded when building the route.
 *  @param completion    Completion handler that is called once the route's calculation is complete.
 *
 *  @deprecated use 'createRouteFrom:to:options:completion:' instead
 */
+ (void)createRouteFrom:(id<PWMapPoint>)startPoint to:(id<PWMapPoint>)endPoint accessibility:(BOOL)accessibility excludedPoints:(NSArray *)excludedPoints completion:(void(^)(PWRoute *route, NSError *error))completion __deprecated;

/**
 *   Instantiates a new PWRoute object using the given parameters. Calculates a route to navigate between the start `PWMapPoint` and the end `PWMapPoint`. The completion handler is called when the route is fully calculated.
 *
 *   @param startPoint    A `PWMapPoint` object representing the start point for the route calculation.
 *   @param endPoint      A `PWMapPoint` object representing the end point for the route calculation.
 *   @param options      A `PWRouteOptions` object specifying the options to use for route calculation. if 'nil', default options will be used.
 *   @param completion    Completion handler that is called once the route's calculation is complete.
 */
+ (void)createRouteFrom:(id<PWMapPoint>)startPoint to:(id<PWMapPoint>)endPoint options:(PWRouteOptions* _Nullable)options completion:(void(^_Nonnull)(PWRoute * _Nullable route, NSError * _Nullable error))completion;

@end
