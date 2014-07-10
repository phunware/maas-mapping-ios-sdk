//
//  PWBuildingAnnotationProtocol.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWMapKit/PWAnnotation.h>

/**
 The `PWAnnotation` protocol is used to provide building annotation-related information to a map view. To use this protocol, adopt it in any custom objects that store or represent annotation data. Each object then serves as the source of information about a single building annotation and provides critical information, such as the annotation’s location on the map. Annotation objects do not provide the visual representation of the annotation but coordinate (in conjunction with the map view’s delegate) the creation of an appropriate `MKAnnotationView` object to handle the display.
 
 This protocol inherits from the `PWAnnotation` protocol. Data for this annotation is provided by Phunware.
 */

@protocol PWBuildingAnnotation <PWAnnotation>

/**
 A description of the building annotation. (read-only)
 */
@property (nonatomic, readonly) NSString *annotationDescription;

/**
 The category associated with the building annotation. (read-only)
 */
@property (nonatomic, readonly) NSString *category;

/**
 The building annotation type. (read-only)
 */
@property (nonatomic, readonly) NSInteger type;

/**
 The image URL associated with the building annotation. This is derived from the type. (read-only)
 */
@property (nonatomic, readonly) NSURL *imageURL;

/**
 Metadata associated with the building annotation. (read-only)
 */
@property (nonatomic, readonly) NSDictionary *metaData;

@end
