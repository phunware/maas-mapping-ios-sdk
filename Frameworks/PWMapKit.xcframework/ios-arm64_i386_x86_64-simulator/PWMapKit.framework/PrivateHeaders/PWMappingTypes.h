//
//  PWMappingTypes.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSUInteger PWCampusIdentifier;
typedef NSUInteger PWBuildingIdentifier;
typedef NSInteger PWBuildingFloorLevel;
typedef NSUInteger PWBuildingFloorResourceIdentifier;

typedef NSUInteger PWAnnotationIdentifier;
typedef NSUInteger PWBuildingAnnotationType;
extern const PWBuildingAnnotationType PWBuildingAnnotationTypeUnknown;
extern const PWBuildingAnnotationType PWBuildingAnnotationTypeRoutingWaypoint;

typedef NSInteger PWMapZoomLevel;
extern const PWMapZoomLevel PWMapZoomLevelShowAtAllLevels;
extern const PWMapZoomLevel PWMapZoomLevelMaximum;
extern const PWMapZoomLevel PWMapZoomLevelMinimum;
