//
//  PWBuildingBuilder.h
//  PWMapKit
//
//  Created by Sam Odom on 10/17/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWBuilding;
@class PWPointOfInterest;
@class PWFloor;
@class PWBuildingFloorResource;
@class PWBuildingFloorReference;
@class PWRoutingWaypoint;
@class PWRouteSegment;

@interface PWBuildingBuilder : NSObject

+ (PWBuilding*)buildBuildingWithValues:(NSDictionary*)values;
+ (PWFloor*)buildFloorWithValues:(NSDictionary*)values;
+ (PWBuildingFloorResource*)buildFloorResourceWithValues:(NSDictionary*)values;
+ (PWBuildingFloorReference*)buildFloorReferenceWithValues:(NSDictionary*)values;
+ (PWPointOfInterest*)buildAnnotationWithValues:(NSDictionary*)values;
+ (PWRoutingWaypoint *)buildWaypointWithValues:(NSDictionary *)values;
+ (PWRouteSegment *)buildSegmentWithValues:(NSDictionary *)values;

@end
