//
//  PWRouteStep+Private.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWRouteStep.h"

@class PWUserLocation;

@interface PWRouteStep ()

@property NSInteger floorID;
@property NSUInteger index;
@property NSArray<id<PWMapPoint>> *points;

- (instancetype)initWithPoints:(NSArray<id<PWMapPoint>> *)points;

- (CLLocationDistance)shortestDistanceFromLocation:(PWUserLocation *)location;

@end
