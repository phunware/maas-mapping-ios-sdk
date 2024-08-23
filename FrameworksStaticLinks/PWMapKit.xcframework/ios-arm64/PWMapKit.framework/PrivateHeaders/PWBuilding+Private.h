//
//  PWBuilding+Private.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWCore/PWCore.h>

#import "PWBuilding.h"
#import "PWMapPoint.h"
#import "PWBuildingManager.h"
#import "PWFloor+Private.h"
#import "PWPointOfInterest.h"
#import "PWRoutingWaypoint.h"
#import "PWMappingUtilities.h"
#import "PWSystemMacros.h"

extern NSTimeInterval const PWBuildingCacheFallbackTimeout;

@interface PWBuilding ()

// Building info
@property (nonatomic) NSInteger identifier;
@property (nonatomic, nullable) NSString *name;
@property (nonatomic, nullable) NSString *venueGUID;
@property (nonatomic) NSInteger campusID;
@property (nonatomic, nullable) NSString *streetAddress;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, nullable) NSArray *pointOfInterestTypes;
@property (nonatomic, strong, nullable) NSString *bundleDirectory;
@property (nonatomic, readwrite, nullable) NSDictionary *userInfo;
@property (nonatomic, nullable) PWFloor *initialFloor;

// Floor info
@property (nonatomic, nullable) NSArray *floors;

// Point info
@property (nonatomic, nullable) NSArray *pois;
@property (nonatomic, nullable) NSDictionary *routePoints;
/*
 Added since v3.0 
 key - the way point identifer
 value - a dictionar which contains all the reachable point and the distance
 eg. 2 meter distance between p1 to p2, 5 meters between p1 to p3, 1 meter between p1 to p4.
    {
    p1:{
        p2:2,
        p3:5,
        p4:1
    }
 }
 */
@property (nonatomic, nullable) NSDictionary *routeSegments;

// For Floyd Warshall algo
@property (nonatomic, nullable) NSArray<NSArray<NSNumber *> *> *fwMatrix;
@property (nonatomic, nullable) NSArray<NSArray<NSNumber *> *> *fwAccessibleMatrix;
@property (nonatomic, nullable) NSDictionary<NSString *, NSNumber *> *fwPidIdxMapping;

- (nullable id<PWMapPoint>)closestTo:(nullable id<PWMapPoint>)point;
- (nullable NSError *)validate;
- (BOOL)isOverview;

@end
