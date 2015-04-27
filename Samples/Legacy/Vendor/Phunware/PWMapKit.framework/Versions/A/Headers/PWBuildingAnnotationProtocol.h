//
//  PWBuildingAnnotationProtocol.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWAnnotationProtocol.h"

extern PWBuildingFloorIdentifier const PWBuildingFloorIdentifierUnknown;

/**
 This protocol is used to provide building annotation-related information to a map view. To use this protocol, adopt it in any custom objects that store or represent annotation data. Each object will then serve as the source of information about a single building annotation and provide critical information, such as the annotation’s location on the map. Annotation objects do not provide the visual representation of the annotation but coordinate the creation of an appropriate `MKAnnotationView` object to handle the display in conjunction with the `PWMapView` delegate.
 
 This protocol inherits from `PWAnnotationProtocol`. Data for this annotation is provided by Phunware.
 
 @discussion Never add annotations conforming to this protocol to the map view using `-addAnnotation(s):`. Phunware internally manages building annotations so that they show and hide automatically at the appropriate zoom and floor levels.
 */


@protocol PWBuildingAnnotationProtocol <PWAnnotationProtocol>

/**
 A description of the building annotation. (read-only)
 */
@property (readonly) NSString *annotationDescription;

/**
 The category associated with the building annotation. (read-only)
 */
@property (readonly) NSString *category;

/**
 The building annotation type. (read-only)
 */
@property (readonly) PWBuildingAnnotationType type;

/**
 The image URL associated with the building annotation. This is derived from the type. (read-only)
 */
@property (readonly) NSURL *imageURL;

/**
 Metadata associated with the building annotation. (read-only)
 */
@property (readonly) NSDictionary *metaData;

/**
 A flag indicating whether the points represented by the annotation are accessible. (read-only)
 */
@property (readonly, getter=isAccessible) BOOL accessible;

/**
 A flag that indicates whether this annotation enabled occlusion. Defaults to `YES`.
 @discussion When `occlusionEnabled` is `NO`, the annotation label will always be shown.
 */
@property (getter=isOcclusionEnabled) BOOL occlusionEnabled;

@end
