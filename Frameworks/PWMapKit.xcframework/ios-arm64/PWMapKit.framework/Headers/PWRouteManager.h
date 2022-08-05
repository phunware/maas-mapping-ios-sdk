//
//  PWRouteManager.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 10/3/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWMapPoint.h"
#import "PWRouteOptions.h"

@class PWRoute;
@class PWDirectionsOptions;

/**
 `PWDirectionsType` specifies the type of directions to use.
 */
typedef NS_CLOSED_ENUM(NSUInteger, PWDirectionsType) {
    /** Both accessible and in-accessible routes are acceptable. */
    PWDirectionsTypeAny,
    /** Only accessible routes are acceptable. */
    PWDirectionsTypeAccessible
};

typedef void(^PWRouteCompletionHandler)(PWRoute *route, NSError *error);
typedef void(^PWGetDistancesCompletionHandler)(NSDictionary *poiDistances, NSError *error);

@interface PWRouteManager : NSObject

+ (instancetype)sharedManager;

- (void)routeFrom:(id<PWMapPoint>)startPoint
               to:(id<PWMapPoint>)endPoint
      withOptions:(PWRouteOptions *)options
       completion:(PWRouteCompletionHandler)completionHandler;

- (void)getShortestDistancesToAllPOIsFrom:(id<PWMapPoint>)startPoint
                              withOptions:(PWRouteOptions *)options
                               completion:(PWGetDistancesCompletionHandler)completion;

@end
