//
//  PWRouteStep.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <CoreLocation/CLLocation.h>

#import "PWMappingTypes.h"

@class MKPolyline;

/**
 A `PWRouteStep` object represents one part of an overall route. Each step in a route corresponds to a single instruction that the user needs to follow.
 
 Do not create instances of this class directly. Instead, request directions to receive route steps as part of an overall PWRoute object. For more information about requesting directions, see `PWDirections`.
 */

@interface PWRouteStep : NSObject

/**
 The detailed step geometry. (read-only)
 @discussion The polyline object in this property contains the geometry for this step. Use the polyline object as an overlay in a map view.
 */
@property (readonly) MKPolyline *polyline;

/**
 The step distance in meters. (read-only)
 @discussion This property reflects the distance the user traverses on the path of the step. It is not a direct distance between the start and end points of the step.
 */
@property (readonly) CLLocationDistance distance;

/**
 The identifier of the floor associated with this particular step object.
 @discussion Currently, there is one `PWRouteStep` object for each floor in a route object.
 */
@property (readonly) PWBuildingFloorIdentifier floorID;

/** The index of the current step. */
@property (readonly) NSUInteger index;

@property (readonly) NSArray *annotations __deprecated;

/** An array of objects that conform to `PWDirectionsWaypointProtocol` which are associated with the route step. */
@property (readonly) NSArray /* PWDirectionsWaypointProtocol */ *points;

@end
