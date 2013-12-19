//
//  PWAnnotation.h
//  PWMapKit
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The `PWAnnotation` protocol is used to provide annotation-related information to a map view. To use this protocol, you adopt it in any custom objects that store or represent annotation data. Each object then serves as the source of information about a single map annotation and provides critical information, such as the annotation’s location on the map. Annotation objects do not provide the visual representation of the annotation but typically coordinate (in conjunction with the map view’s delegate) the creation of an appropriate `PWAnnotationView` object to handle the display.
 
 An object that adopts this protocol must implement the `location`, `floorID`, `zoomLevel`, and `maxZoomLevel` properties. The `isExit` method of this protocol is optional.
 */

@protocol PWAnnotation <NSObject>

/**
 The center point (specified as a building coordinate) of the annotation.
 @note This is a required property.
 */
@property (nonatomic, assign) CGPoint location;

/**
 The floor ID for which this annotation applies.
 @discussion The floor ID determines whether or not to display the annotation for the current floor. If the floor ID of the current floor and the floor ID of the annotation match then the annotation will be dispalyed (if it's in the visible area).
 @note This is a required property.
 */
@property (nonatomic, assign) NSInteger floorID;

/**
 The minimum zoom level for which this annotation will appear.
 @discussion If the user zooms out before the `zoomLevel` the annotation will no longer be visible.
 @note This is a required property.
 */
@property (nonatomic, assign) NSInteger zoomLevel;

/**
 The maximum zoom level for which this annotation will appear.
 @discussion If the user zooms in past the `maximumZoomLevel` the annotation will no longer be visible.
 @note This is a required property.
 */
@property (nonatomic, assign) NSInteger maxZoomLevel;

/**
 Specifies whether or not this annotation is an exit. This is used for routing purposes and can be ignored for custom annotations.
 @note This is NOT a required property.
 */
@property (nonatomic, assign) BOOL isExit;

@end
