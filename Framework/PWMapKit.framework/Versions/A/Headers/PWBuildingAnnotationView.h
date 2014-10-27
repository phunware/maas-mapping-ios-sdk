//
//  PWBuildingAnnotationView.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "PWBuildingAnnotationProtocol.h"

@class PWAnnotationLabel;

/**
 The `PWAnnotationView` class is responsible for presenting visual building annotations in a map view. Annotation views are loosely coupled to a corresponding building annotation object that corresponds to the `PWBuildingAnnotation` protocol. When an annotation’s coordinate point is in the visible region, the map view asks its delegate to provide a corresponding annotation view. Annotation views may be recycled later and put into a reuse queue maintained by the map view.
 */

@interface PWBuildingAnnotationView : MKAnnotationView

/**
 The annotation label associated with the view. The annotation label stroke color and stroke width can be customized. 
 
 @discussion The annotation label is automatically displayed or hidden based on whether or not it occludes other annotation view images or labels.
 */
@property (nonatomic, weak) PWAnnotationLabel *label;

/**
 Initializes and returns a new annotation view.
 @param annotation The building annotation object to associate with the new view.
 @param reuseIdentifier If you plan to reuse the annotation view for similar types of annotations, pass a string to identify it. Although you can pass `nil` if you do not intend to reuse the view, reusing annotation views is generally recommended.
 @return The initialized building annotation view or `nil` if there was a problem initializing the object.
 */
- (instancetype)initWithAnnotation:(id <PWBuildingAnnotationProtocol>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
