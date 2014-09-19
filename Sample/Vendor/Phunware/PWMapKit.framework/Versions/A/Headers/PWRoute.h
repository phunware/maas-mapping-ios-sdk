//
//  PWRoute.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The `PWRoute` class defines a single route that the user can follow between a requested start and end point. The route object defines the geometry for the route and includes route information you can display to the user, such as the name of the route, its distance and the expected travel time.
 
 You do not create instances of this class directly. Instead, you receive route objects when you request directions. For more information about requesting directions, see `PWDirections` Class Reference.
 */

@interface PWRoute : NSObject

/**
 The name assigned to the route. The string can describe the route using one of the route’s significant features. (read-only)
 @discussion You can display this string to the user from your app’s user interface so that the user can distinguish one route from another.
 */
@property (nonatomic, readonly) NSString *name;

/**
 The route distance in meters. (read-only)
 @discussion This property reflects the distance the user covers while traversing the route's path. It is not a direct distance between the start and end points of the route.
 */
@property (nonatomic, readonly) CLLocationDistance distance;

/**
 The expected travel time in seconds. (read-only)
 @discussion This expected travel time reflects the time it takes to traverse the route under ideal conditions. The actual amount of time may vary.
 */
@property (nonatomic, readonly) NSTimeInterval expectedTravelTime;

/**
 The detailed route geometry. (read-only)
 @discussion The polyline object in this property reflects the complete path of the route, including all of its steps. You can use the polyline object as an overlay in a map view.
 */
@property (nonatomic, readonly) MKPolyline *polyline;


/**
 The array of steps that comprise the overall route. (read-only)
 @discussion The array contains one or more `PWRouteStep` objects representing distinct portions of the route. Each step corresponds to a single floor seqeuence that must be followed along the route.
 */
@property (nonatomic, readonly) NSArray *steps;


/**
 A Boolean value that indicates whether the PWRoute object is accessible. (read-only)
 */
@property (nonatomic, readonly, getter=isAccessible) BOOL accessible;

/**
 
 */
- (NSArray *)stepsForFloorID:(NSUInteger)floorID;

@end
