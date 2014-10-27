//
//  PWBuildingAnnotationProtocol.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWMapKit/PWAnnotationProtocol.h>

/**
 This protocol is used to provide building annotation-related information to a map view. To use this protocol, adopt it in any custom objects that store or represent annotation data. Each object then serves as the source of information about a single building annotation and provides critical information, such as the annotation’s location on the map. Annotation objects do not provide the visual representation of the annotation but coordinate the creation of an appropriate `MKAnnotationView` object to handle the display in conjunction with the `PWMapView` delegate.
 
 This protocol inherits from `PWAnnotationProtocol`. Data for this annotation is provided by Phunware.
 */

extern PWBuildingFloorIdentifier const PWBuildingFloorIdentifierDefault;

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
 A flag indicating whether or not the points represented by the annotation is accessible. (read-only)
 */
@property (readonly, getter=isAccessible) BOOL accessible;

@end
