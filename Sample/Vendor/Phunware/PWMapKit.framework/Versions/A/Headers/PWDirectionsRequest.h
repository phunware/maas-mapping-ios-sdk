//
//  PWDirectionsRequest.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <PWLocation/PWLocationProtocol.h>

#import "PWAnnotationProtocol.h"

@class PWDirectionsOptions;

/**
 `PWDirectionsType` specifies the type of directions to use.
 */
typedef NS_ENUM(NSUInteger, PWDirectionsType) {
    PWDirectionsTypeAny,
    PWDirectionsTypeAccessible
};


/**
 The `PWDirectionsRequest` class is used by apps that work with indoor directions. To request directions, create a new instance of this class and configure it with the start and end points you need. Then, create a `PWDirections` object and use the methods of that class to initiate the request and process the results.
 */
@interface PWDirectionsRequest : NSObject


/**
 The waypoints (i.e. start and end points) to use for calculating directions. This array will always contain exactly two points.
 */
@property (readonly) NSArray *waypoints;


/**
 The options to use for calculating directions.
 */
@property (readonly) PWDirectionsOptions *options;


/**
 Creates, initializes and returns a `PWDirectionsRequest` object with the specified waypoints and routing options.
 @param waypoints The source and destination locations. These locations must conform to the `PWDirectionsWaypoint` protocol. If fewer than two points are provided, an assertion failure will be thrown. If more than two points are provided, the first and last waypoints in the array will be used as the end points and all other points will be ignored.
 @param options The directions options for this request. The provided options will be copied. 
 @return An initialized directions request object.
 */
+ (instancetype)requestWithWaypoints:(NSArray*)waypoints options:(PWDirectionsOptions*)options;



#pragma mark - Deprecated

/**
 The starting point for routing directions. This value will be `nil` if the request is initialized with `initWithLocation:destination:type:`. (read-only)
 @discussion This property has been deprecated. Use `(PWDirectionsWaypoint) waypoints.firstObject` instead.
 */
@property (readonly) id<PWAnnotationProtocol> source __deprecated;

/**
 The end point for routing directions. (read-only)
 @discussion This property has been deprecated. Use `(PWDirectionsWaypoint) waypoints.lastObject` instead.
 */
@property (readonly) id<PWAnnotationProtocol> destination __deprecated;

/**
 The source location object. This value will be `nil` if the request is initialized with `initWithSource:destination:type:`. (read-only)
 @discussion This property has been deprecated. Use `(PWDirectionsWaypoint) waypoints.firstObject` instead.
 */
@property (readonly) id<PWLocation> location __deprecated;

/**
 The type of directions this request applies to.
 @discussion This property has been deprecated. Use `options` instead.
 */
@property (readonly) PWDirectionsType type __deprecated;

/**
 Initializes and returns a `PWDirectionsRequest` object with a source and destination annotation.
 @param source The source annotation. This object must conform to `PWAnnotationProtocol` and cannot be `nil`.
 @param destination The destination annotation. This object must conform to `PWAnnotationProtocol` protocol and cannot be `nil`.
 @param type The type of directions for this request.
 @return The initialized directions request object.
 */
- (instancetype)initWithSource:(id<PWAnnotationProtocol>)source destination:(id<PWAnnotationProtocol>)destination type:(PWDirectionsType)type __deprecated;

/**
 Initializes and returns a `PWDirectionsRequest` object with a source location and destination annotation.
 @param location The source location. This object must conform to the `PWLocation` protocol and cannot be `nil`.
 @param destination The destination annotation. This object must conform to `PWAnnotationProtocol` and cannot be `nil`.
 @param type The type of directions for this request.
 @return An initialized directions request object.
 */
- (instancetype)initWithLocation:(id<PWLocation>)location destination:(id<PWAnnotationProtocol>)destination type:(PWDirectionsType)type __deprecated;


@end
