//
//  PWRoute.h
//  PWMapKit
//
//  Created by Steven Spry on 5/12/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PWBuilding.h"
#import "PWPointOfInterest.h"

/**
 *  A PWRoute represents a route calculated for the user from within a building's boundaries start point of interest to end point of interest.
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
 *  A reference to the origin, or start point of interest, for the route.
 */
@property (nonatomic,readonly) PWPointOfInterest *startPointOfInterest;

/**
 *  A reference to the destination, or end point of interest, for the route.
 */
@property (nonatomic,readonly) PWPointOfInterest *endPointOfInterest;

/**
 *  An array of PWRouteInstruction objects containing instructions to follow the route path.
 */
@property (nonatomic,readonly) NSMutableArray *routeInstructions;

/**
 *  An integer number representing the total distance of the route expressed in meters.
 */
@property (nonatomic,readonly) NSInteger distance;

/**
 *  An integer number representing the estimated time of the route expressed in seconds.
 */
@property (nonatomic,readonly) NSInteger estimatedTime;

/**
 *  A BOOL value that returns YES if the route was calculated with accessibility.
 */
@property (nonatomic, readonly) BOOL isAccessible;

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
 *  @param completion    Completion handler that is called once the routes calculation is complete.
 */
+ (void)initRouteFrom:(PWPointOfInterest *)startPoint to:(PWPointOfInterest *)endPoint accessibility:(BOOL)accessibility completion:(void(^)(PWRoute *route, NSError *error))completion;

@end
