//
//  PWMapKitDefines.h
//  PWMapKit
//
//  Created by Illya Busigin on 5/1/13.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_CLOSED_ENUM(NSUInteger, PWMapPointSource) {
    PWMapPointSourceCustomPOI,
    PWMapPointSourcePOI,
    PWMapPointSourceWaypoint
};

typedef NS_CLOSED_ENUM(NSUInteger, PWMapKitErrorCode) {
    PWMapKitErrorCodeInvalidArgument = 1000,
    PWMapKitErrorCodeBuildingWithoutID = 1001,
    PWMapKitErrorCodeBuildingWithoutName = 1002,
    PWMapKitErrorCodeBuildingWithoutFloors = 1003,
    PWMapKitErrorCodeFloorWithoutID = 1101,
    PWMapKitErrorCodeFloorWithoutName = 1102,
    PWMapKitErrorCodeFloorWithInvalidBoundingBox = 1103,
    PWMapKitErrorCodeFloorPDFNotLoaded = 1104,
    PWMapKitErrorCodePOIWithoutBuildingFloor = 1201,
    PWMapKitErrorCodePOIWithInvalidCoordinate = 1202,
    PWMapKitErrorCodePOIWithoutComforming = 1203,
    PWMapKitErrorCodeRouteWithoutFloorStep = 1301,
    PWMapKitErrorCodeRouteWithoutManeuver = 1302,
    PWMapKitErrorCodeRouteStepInvalid = 1310,
    PWMapKitErrorCodeRouteManeuverInvalid = 1320,
};

#pragma mark - API

extern NSString *const PWMapKitAPIVersion;
extern NSString *const PWMapKitAPIHost;
extern NSString *const PWMapKitS3Host;

#pragma mark - POI

extern CGFloat const PWPOIIconWidthOniPhone;

#pragma mark - POI Types

extern NSInteger const PWMapKitPOITypeOfElevator;
extern NSInteger const PWMapKitPOITypeOfStairs;
extern NSInteger const PWMapKitPOITypeOfEscalator;

#pragma mark - Cache

extern NSString *const PWMapKitCacheName;

#pragma mark - Error

extern NSString *const PWMapKitErrorDomain;


