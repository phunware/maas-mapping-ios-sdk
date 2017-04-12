//
//  PWAPIManager.h
//  PWCore
//
//  Created by Xiangwei Wang on 06/12/2016.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A generic class for making HTTP/HTTPS calls, and the authentication header will be automatically added.
 */
@interface PWAPIManager : NSObject

/**
 Shared `PWAPIManager`
 */
+ (PWAPIManager *)sharedInstance;

/**
 Send a `GET` request for specific endpoint and parameters.
 @param endpoint The endpoint for the request.
 @param parameters The parameters for the request.
 @param completion A block that returns the HTTP response or error.
 */
- (void)get:(NSString *)endpoint withParameters:(NSDictionary *)parameters withCompletion:(void(^)(id response, NSError *error))completion;

/**
 Send a `GET` request for specific endpoint and parameters, and the response may be fetched from the cache.
 @param endpoint The endpoint for the request.
 @param parameters The parameters for the request.
 @param completion A block that returns the HTTP response or error.
 @discussion The HTTP response is cached for 24 hours, so it will return you the cached data if you request again in 24 hours. You can use `get:...` if you want to get the real-time response.
 */
- (void)getCached:(NSString *)endpoint withParameters:(NSDictionary *)parameters withCompletion:(void(^)(id response, NSError *error))completion;

/**
 Send a `POST` request for specific endpoint and parameters.
 @param endpoint The endpoint for the request.
 @param parameters The parameters for the request.
 @param completion A block that returns the HTTP response or error.
 */
- (void)post:(NSString *)endpoint withParameters:(NSDictionary *)parameters withCompletion:(void(^)(id response, NSError *error))completion;

/**
 Send a request for specific endpoint, parameters and HTTP method.
 @param httpMethod The http request for the request.
 @param endpoint The endpoint for the request.
 @param parameters The parameters for the request.
 @param completion A block that returns the HTTP response or error.
 */
- (void)request:(NSString *)endpoint withHTTPMethod:(NSString *)httpMethod withParameters:(NSDictionary *)parameters withCompletion:(void(^)(id response, NSError *error))completion;

@end
