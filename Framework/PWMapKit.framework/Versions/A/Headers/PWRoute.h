//
//  PWRoute.h
//  PWMapKit
//
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PWBuilding.h"
#import "PWPointOfInterest.h"
#import "PWMapPoint.h"

/**
 *  A PWRoute represents a route calculated for the user from within a building's boundaries; start point of interest to end point of interest.
 */
@interface PWRoute : NSObject

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  A reference to the route's building object.
 */
@property (nonatomic,readonly) PWBuilding *building;

/**
 *  A reference to the origin, or start point for the route.
 */
@property (readonly) id<PWMapPoint> startPoint;

/**
 *  A reference to the destination, or end point for the route.
 */
@property (readonly) id<PWMapPoint> endPoint;

/**
 *  A reference to the origin, or start point of interest, for the route.
 * @discussion Change to use `startPoint`
 */
@property (nonatomic,readonly) PWPointOfInterest *startPointOfInterest __deprecated;

/**
 *  A reference to the destination, or end point of interest, for the route.
 * @discussion Change to use `endPoint`
 */
@property (nonatomic,readonly) PWPointOfInterest *endPointOfInterest __deprecated;

/**
 *  An array of PWRouteInstruction objects containing instructions to follow the route path.
 */
@property (nonatomic,readonly) NSArray *routeInstructions;

/**
 *  An integer representing the total distance of the route expressed in meters.
 */
@property (nonatomic,readonly) NSInteger distance;

/**
 *  An integer representing the estimated time of the route expressed in seconds.
 */
@property (nonatomic,readonly) NSInteger estimatedTime;

/**
 *  A BOOL value that returns YES if the route was calculated with accessibility.
 */
@property (nonatomic, readonly, getter=isAccessible) BOOL accessible;

/**---------------------------------------------------------------------------------------
 * @name Class Methods
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Instantiates a new PWRoute object using the given parameters. Calculates a route to navigate between the start POI and the end POI. The completion handler is called when the route is fully calculated.
 *
 *  @param startPoint    PWPointOfInterest object representing the start point for the route calculation.
 *  @param endPoint      PWPointOfInterest object representing the end point for the route calculation.
 *  @param accessibility BOOL Value to tell the route init if accessibility should be considered to calculate the route.
 *  @param completion    Completion handler that is called once the route's calculation is complete.
 *  @discussion Please change to use `createRouteFrom: to: accessibility: excludedPoints: completion:`
 */
+ (void)initRouteFrom:(PWPointOfInterest *)startPoint to:(PWPointOfInterest *)endPoint accessibility:(BOOL)accessibility completion:(void(^)(PWRoute *route, NSError *error))completion __deprecated;

/**
 *  Instantiates a new PWRoute object using the given parameters. Calculates a route to navigate between the start POI and the end POI. The completion handler is called when the route is fully calculated.
 *
 *  @param startPoint    A `PWMapPoint` object representing the start point for the route calculation.
 *  @param endPoint      A `PWMapPoint` object representing the end point for the route calculation.
 *  @param accessibility A BOOL value to tell the route init if accessibility should be considered to calculate the route.
 *  @param excludedPoints An array of points to tell the route result should exclude.
 *  @param completion    Completion handler that is called once the route's calculation is complete.
 */
+ (void)createRouteFrom:(id<PWMapPoint>)startPoint to:(id<PWMapPoint>)endPoint accessibility:(BOOL)accessibility excludedPoints:(NSArray *)excludedPoints completion:(void(^)(PWRoute *route, NSError *error))completion;

@end
