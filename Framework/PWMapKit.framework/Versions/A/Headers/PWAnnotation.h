//
//  PWAnnotation.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <MapKit/MKAnnotation.h>

/**
 The `PWAnnotation` protocol is used to provide annotation-related information to a map view. To use this protocol, adopt it in any custom objects that store or represent annotation data. Each object then serves as the source of information about a single map annotation and provides critical information, such as the annotation’s location on the map. Annotation objects do not provide the visual representation of the annotation but typically coordinate (in conjunction with the map view’s delegate) the creation of an appropriate `PWAnnotationView` object to handle the display.
 
 An object that adopts this protocol must implement the `annotationID` and `floorID` properties.
 */

extern NSInteger const kPWAnnotationIDUndefined;

@protocol PWAnnotation <MKAnnotation>

/**
 The annotation identifier as specified by the mapping service. These annotation identifiers are used for uniquely identifing annotations and for routing. If you are creating location annotations you should initialize this value to `kPWAnnotationIDUndefined`.
*/
@property (nonatomic, assign) NSUInteger annotationID;

/**
 The floor identifier for which this annotation applies.
 @discussion The floor identifier determines whether or not to display the annotation for the current floor. If the floor identifier of the current floor and the floor identifier of the annotation match, then the annotation will be dispalyed (if it's in the visible area).
 */
@property (nonatomic, assign) NSInteger floorID;

@end
