//
//  PWDirections.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWDirectionsRequest;
@class PWDirectionsResponse;
@class PWRoute;
@class PWDirectionsOptions;

typedef void (^PWDirectionsHandler)(PWDirectionsResponse *response, NSError *error);

/**
 A `PWDirections` object provides you with the ability to calculate routes using data from Phunware servers. You can use instances of this class to get walking directions based on the waypoints and options provided. The directions object performs synchronously or asynchronously, depending on whether a completion block is provided.
 */

@interface PWDirections : NSObject


/**
 The start and end points of the requested directions.
 */
@property (readonly) NSArray *waypoints;


/**
 This property holds the routing request options (such as accessibility requirements).
 */
@property (readonly) PWDirectionsOptions *options;


/**
 Once the route is found and directions are calculated, the route is stored in this property. The initial value is `nil`.
 */
@property (readonly) PWRoute *route;


/**
 Initializes a directions object with the provided waypoints and routing options.
 */
- (instancetype)initWithWaypoints:(NSArray*)waypoints options:(PWDirectionsOptions*)options;


/**
 Calculates the requested route information synchronously.
 @discussion This method calculates a route and stores the result in the `route` property. If an error occurs, the `route` property will still be missing.
 */
- (void)calculateDirections;

/**
 Begins calculating the requested route information asynchronously.
 @param completion The block to execute when directions are ready or when an error occurs. This parameter cannot be `nil`.
 @discussion This method initiates the calculation of directions in the background, then calls your completion handler block with the results. The completion handler is executed on your the main thread and must handle a directions response or error. If a route is found, then the `route` property of this object is populated.
 */
- (void)calculateDirectionsWithCompletionHandler:(PWDirectionsHandler)completion;


#pragma mark - Deprecated

/**
 Initializes and returns a directions object using the specified request.
 @param request The request object containing the start and end points of the route. This parameter must not be `nil`.
 @return An initialized directions object.
 */
- (instancetype)initWithRequest:(PWDirectionsRequest *)request __deprecated;


@end
