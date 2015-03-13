//
//  PWRoute.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWMappingTypes.h"

/**
 The `PWRoute` class defines a single route that the user can follow between a requested start and end point. The route object defines the geometry for the route and includes route information you can display to the user, such as the name of the route, its distance and the expected travel time.
 
 Do not create instances of this class directly. Instead, request directions to receive route objects. For more information about requesting directions, see `PWDirections` Class Reference.
 */

@interface PWRoute : NSObject

/**
 The route distance in meters. (read-only)
 @discussion This property reflects the distance the user traverses on the route's path. It is not a direct distance between the start and end points of the route.
 */
@property (readonly) CLLocationDistance distance;

/**
 The array of steps that comprise the overall route. (read-only)
 @discussion The array contains one or more `PWRouteStep` objects representing distinct portions of the route. Each step corresponds to a single floor sequence that must be followed along the route.
 */
@property (readonly) NSArray *steps;

/**
 A Boolean value that indicates whether the PWRoute object is accessible. (read-only)
 */
@property (readonly, getter=isAccessible) BOOL accessible;

@end
