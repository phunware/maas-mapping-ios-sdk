//
//  PWMappingSerializationKeys.h
//  PWMapKit
//
//  Created by Sam Odom on 10/17/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Building

extern NSString * const PWBuildingVenueIdentifierKey;
extern NSString * const PWBuildingCampusIdentifierKey;
extern NSString * const PWBuildingBuildingIdentifierKey;
extern NSString * const PWBuildingNameKey;
extern NSString * const PWBuildingStreetAddressKey;
extern NSString * const PWBuildingFloorsKey;


#pragma mark - Floor

extern NSString * const PWBuildingFloorNameKey;
extern NSString * const PWBuildingFloorBuildingIdentifierKey;
extern NSString * const PWBuildingFloorFloorIdentifierKey;
extern NSString * const PWBuildingFloorLevelKey;
extern NSString * const PWBuildingFloorResourcesKey;
extern NSString * const PWBuildingFloorCoordinateSpaceKey;
extern NSString * const PWBuildingFloorReferencePointsKey;
extern NSString * const PWBuildingFloorIsDefaultKey;

#pragma mark - Floor Resource

extern NSString * const PWBuildingFloorResourceIdentifierKey;
extern NSString * const PWBuildingFloorResourceFloorIdentifierKey;
extern NSString * const PWBuildingFloorResourcePDFURLKey;
extern NSString * const PWBuildingFloorResourceSVGURLKey;
extern NSString * const PWBuildingFloorResourceZoomLevelKey;
extern NSString * const PWBuildingFloorResourceCreationDateKey;
extern NSString * const PWBuildingFloorResourceModificationDateKey;

#pragma mark - Floor Reference

extern NSString * const PWBuildingFloorReferenceTopLeftKey;
extern NSString * const PWBuildingFloorReferenceTopRightKey;
extern NSString * const PWBuildingFloorReferenceBottomLeftKey;
extern NSString * const PWBuildingFloorReferenceBottomRightKey;
extern NSString * const PWBuildingFloorReferenceAngleKey;

#pragma mark - Building Annotation

extern NSString * const PWBuildingAnnotationAnnotationIdentifierKey;
extern NSString * const PWBuildingAnnotationFloorIdentifierKey;
extern NSString * const PWBuildingAnnotationBuildingIdentifierKey;
extern NSString * const PWBuildingAnnotationTitleKey;
extern NSString * const PWBuildingAnnotationDescriptionKey;
extern NSString * const PWBuildingAnnotationZoomLevelKey;
extern NSString * const PWBuildingAnnotationMaxZoomLevelKey;
extern NSString * const PWBuildingAnnotationTypeKey;
extern NSString * const PWBuildingAnnotationMetaDataKey;
extern NSString * const PWBuildingAnnotationLocationKey;
extern NSString * const PWBuildingAnnotationCategoryKey;
extern NSString * const PWBuildingAnnotationSubtitleKey;
extern NSString * const PWBuildingAnnotationPortalIdentifierKey;
extern NSString * const PWBuildingAnnotationLevelKey;
extern NSString * const PWBuildingAnnotationAccessibilityFlagKey;
extern NSString * const PWBuildingAnnotationExitFlagKey;
extern NSString * const PWBuildingAnnotationActiveFlagKey;
extern NSString * const PWBuildingAnnotationVisualImpairedFlagKey;
extern NSString * const PWBuildingAnnotationCustomIconImageURLKey;

#pragma mark - Route Annotation

extern NSString * const PWRoutingWaypointCoordinateKey;
extern NSString * const PWRoutingWaypointAnnotationIdentifierKey;
extern NSString * const PWRoutingWaypointFloorIdentifierKey;
extern NSString * const PWRoutingWaypointBuildingIdentifierKey;
extern NSString * const PWRoutingWaypointExitFlagKey;
extern NSString * const PWRoutingWaypointActiveFlagKey;
extern NSString * const PWRoutingWaypointAccessibleFlagKey;
extern NSString * const PWRoutingWaypointVisualImpairedFlagKey;
extern NSString * const PWRoutingWaypointTitleFlagKey;
extern NSString * const PWRoutingWaypointMetaDataKey;

#pragma mark - Route Segment

extern NSString * const PWRouteSegmentFloorIdentifierKey;
extern NSString * const PWRouteSegmentStartPointIdentifierKey;
extern NSString * const PWRouteSegmentEndPointIdentifierKey;

#pragma mark - Map Document

extern NSString * const PWMapDocumentResourceValuesKey;
extern NSString * const PWMapDocumentPDFValuesKey;

#pragma mark - PDF Document

extern NSString * const PWPDFDocumentFileURLKey;

#pragma mark - Common

extern NSString * const PWLatitudeKey;
extern NSString * const PWLongitudeKey;
