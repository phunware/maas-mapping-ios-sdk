//
//  PWRoutingWaypoint.h
//  PWMapKit
//
//  Created by Sam Odom on 3/20/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWMapPoint.h"

@protocol PWMapPoint;
@class PWFloor;

@interface PWRoutingWaypoint : NSObject <PWMapPoint>

/**
 * The `PWFloor` object that the point-of-interest belongs to.
 */
@property (nonatomic, readonly, weak, nullable) PWFloor *floor;

/**
 * Metadata associated with the waypoint
 */
@property (nonatomic, readonly, nullable) NSDictionary *metaData;

@end
