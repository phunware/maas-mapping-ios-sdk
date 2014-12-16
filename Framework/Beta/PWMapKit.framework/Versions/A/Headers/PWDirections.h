//
//  PWDirections.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWDirectionsRequest;
@class PWDirectionsResponse;

typedef void (^PWDirectionsHandler)(PWDirectionsResponse *response, NSError *error);

/**
 A `PWDirections` object provides you with route-based directions data from Phunware servers. You can use instances of this class to get walking directions based on the data in a `PWDirectionsRequest` object that you provide. The directions object passes your request to the Phunware servers and returns the requested information to a block that you provide.
 
 Each directions object handles a single request for directions, although you can cancel and restart that request as needed. You can create multiple instances of this class and process different route requests at the same time, but you should only make requests when you plan to present the corresponding route information to the user.
 */

@interface PWDirections : NSObject

/**
 Initializes and returns a directions object using the specified request.
 @param request The request object containing the start and end points of the route. This parameter must not be `nil`.
 @return An initialized directions object.
 */
- (instancetype)initWithRequest:(PWDirectionsRequest *)request;

/**
 Begins calculating the requested route information asynchronously.
 @param completion The block to execute when the directions are ready or when an error occurs. This parameter cannot be `nil`.
 @discussion This method initiates the request for directions and calls your completion handler block with the results. Your completion handler is executed on your app’s main thread. The implementation of your handler should check for errors and then incorporate the response data as appropriate.
 
 If you call this method while a previous request is in progress, this method calls your completion handler with an error. You can determine if a request is in process by checking the value of the calculating property. You can also cancel a request as needed.
 */
- (void)calculateDirectionsWithCompletionHandler:(PWDirectionsHandler)completion;

@end
