//
//  PWDirectionsResponse.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

@class PWDirectionsRequest;

/**
 The `PWDirectionsResponse` class provides a container for route information returned by the Phunware servers. Do not create instances of this class directly. Instead, initiate a request for directions between two points by calling the calculateDirectionsWithCompletionHandler: method of a PWDirections object. An instance of this class will be received as the result.
*/
@interface PWDirectionsResponse : NSObject

/**
 The original directions request object. (read-only)
 */
@property (readonly) PWDirectionsRequest *request;

/**
 An array of route objects representing the directions between the start and end points. (read-only)
 @discussion The array contains one or more `PWRoute` objects, each of which represents a possible set of directions for the user to follow. If you did not request alternate routes in the original directions request, this array contains at most one object.
 
 Each route object contains geometry information that you can use to display that route in your app’s map view.
 */
@property (readonly) NSArray *routes;

@end
