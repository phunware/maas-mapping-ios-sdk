//
//  PWRouteStep.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A `PWRouteStep` object represents one part of an overall route. Each step in a route corresponds to a single instruction that would need to be followed by the user.
 
 You do not create instances of this class directly. Instead, you can receive route steps as part of an overall PWRoute object when you request directions. For more information about requesting directions, see `PWDirections`.
 */

@interface PWRouteStep : NSObject

/**
 The detailed step geometry. (read-only)
 @discussion The polyline object in this property contains the geometry for this step. You can use the polyline object as an overlay in a map view.
 */
@property (nonatomic, readonly) MKPolyline *polyline;

/**
 The step distance in meters. (read-only)
 @discussion This property reflects the distance that the user covers while traversing the path of the step. It is not a direct distance between the start and end points of the step.
 */
@property (nonatomic, readonly) CLLocationDistance distance; // step distance in meters

/**
 The identifier of the floor associated with this particular step object.
 @discussion Currently, there is one `PWRouteStep` object for each floor in a route object.
 */
@property (nonatomic, readonly) NSUInteger floorID;

/** The index of the current step. */
@property (nonatomic, readonly) NSUInteger index;

/** An array of `PWRouteAnnotation` objects associated with the route step. */
@property (nonatomic, readonly) NSArray *annotations;

@end
