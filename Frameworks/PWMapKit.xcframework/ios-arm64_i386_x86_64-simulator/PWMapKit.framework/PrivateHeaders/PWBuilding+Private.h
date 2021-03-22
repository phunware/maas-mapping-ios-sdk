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
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *venueGUID;
@property (nonatomic) NSInteger campusID;
@property (nonatomic) NSString *streetAddress;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSArray *pointOfInterestTypes;
@property (nonatomic, strong) NSString *bundleDirectory;
@property (nonatomic, readwrite) NSDictionary *userInfo;

// Floor info
@property (nonatomic) NSArray *floors;

// Point info
@property (nonatomic) NSArray *pois;
@property (nonatomic) NSDictionary *routePoints;
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
@property (nonatomic) NSDictionary *routeSegments;

// For Floyd Warshall algo
@property (nonatomic) NSArray<NSArray<NSNumber *> *> *fwMatrix;
@property (nonatomic) NSArray<NSArray<NSNumber *> *> *fwAccessibleMatrix;
@property (nonatomic) NSDictionary<NSString *, NSNumber *> *fwPidIdxMapping;

- (id<PWMapPoint>)closestTo:(id<PWMapPoint>)point;

- (NSError *)validate;

@end
