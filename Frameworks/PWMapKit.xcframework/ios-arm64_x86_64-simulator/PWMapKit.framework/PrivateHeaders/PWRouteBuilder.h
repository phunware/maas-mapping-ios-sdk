//
//  PWRouteBuilder.h
//  PWMapKit
//
//  Created by Sam Odom on 10/22/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWRoute;
@protocol PWMapPoint;

@interface PWRouteBuilder : NSObject

+ (PWRoute*)buildRouteWithPoints:(NSArray<id<PWMapPoint>> *)points;
+ (void)calculateManeuversForRoute:(PWRoute *)route landmarksEnabled:(BOOL)landmarksEnabled;

@end
