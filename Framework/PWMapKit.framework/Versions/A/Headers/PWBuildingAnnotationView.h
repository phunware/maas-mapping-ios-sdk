//
//  PWBuildingAnnotationView.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

@class PWAnnotationLabel;

/**
 The `PWAnnotationView` class is responsible for presenting visual building annotations in a map view. Annotation views are loosely coupled with a corresponding building annotation object that conforms to the `PWBuildingAnnotation` protocol. When an annotation’s coordinate is in the visible region, the map view asks its delegate to provide a corresponding annotation view. Annotation views may be recycled later and put into a reuse queue maintained by the map view.
 */

@interface PWBuildingAnnotationView : MKAnnotationView

/**
 The annotation label associated with the view. The annotation label stroke color and stroke width can be customized. 
 
 @discussion The annotation label is automatically displayed or hidden based on whether or not it occludes other annotation view images or labels.
 */
@property (nonatomic, weak) PWAnnotationLabel *label;

@end
