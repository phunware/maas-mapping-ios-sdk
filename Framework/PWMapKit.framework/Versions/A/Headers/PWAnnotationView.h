//
//  PWAnnotationView.h
//
//  Created by Jesse Collis on 9/05/12. Modified by Phunware, Inc.
//  Copyright (c) 2012, Jesse Collis PWJC Multimedia Design. <jesse@jcmultimedia.com.au>
//  All rights reserved.
//
//  * Redistribution and use in source and binary forms, with or without 
//   modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright 
//   notice, this list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright 
//   notice, this list of conditions and the following disclaimer in the 
//   documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY 
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND 
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
//

#import <UIKit/UIKit.h>

@protocol PWAnnotation;

/**
 The `PWAnnotationView` class provides a concrete annotation view that displays a badge icon like the ones found in the Maps application. Using this class, you can configure the badge, a marker view, and the label.
 */

@interface PWAnnotationView : UIView

/**
 The annotation object currently associated with the view.
 @discussion You should not change the value of this property directly. This property contains a non-nil value only while the annotation view is visible on the map. If the view is queued and waiting to be reused, the value is nil.
 */
@property (nonatomic, strong) id<PWAnnotation> annotation;

/**
 The position of the annotation based on the map coordinate space.
 */
@property (nonatomic, assign) CGPoint position;

/**
 The offset (in point) at which to display the view.
 @discussion By default, the center point of an annotation view is placed at the coordinate point of the associated annotation. You can use this property to reposition the annotation view as needed. This x and y offset values are measured in point. Positive offset values move the annotation view down and to the right, while negative values move it up and to the left
 */
@property (nonatomic, assign) CGPoint centerOffset;

/**
 The string that identifies that this annotation view is reusable.
 @discussion You specify the reuse identifier when you create the view. You use this type later to retrieve an annotation view that was created previously but which is currently unused because its annotation is not on screen.
 
 If you define distinctly different types of annotations (with distinctly different annotation views to go with them), you can differentiate between the annotation types by specifying different reuse identifiers for each one
 */
@property (nonatomic, strong) NSString *reuseIdentifier;

/**
 The image view associated with the annotation view.
 @discussion This is the image view that would display the annotation badge.
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 The marker view which appears on top of the image view.
 @discussion You can use the marker view to showcase a selected annotation.
 */
@property (nonatomic, strong) UIImageView *markerView;

/**
 The label view that appears below the annotation badge view.
 */
@property (nonatomic, weak) UILabel *label;

///-----------------------------
/// @name Initialization & Setup
///-----------------------------

/**
 Initializes and returns a new annotation view.
 @param frame The frame of the annotation view.
 @param annotation The annotation object to associate with the new view.
 @param reuseIdentifier If you plan to reuse the annotation view for similar types of annotations, pass a string to identify it. Although you can pass nil if you do not intend to reuse the view, reusing annotation views is generally recommended.
 @return The initialized annotation view or nil if there was a problem initializing the object.
 @discussion The reuse identifier provides a way for you to improve performance by recycling annotation views as they are scrolled on and off of the map. As views are no longer needed, they are moved to a reuse queue by the map view. When a new annotation becomes visible, your application can request a view for that annotation by passing the appropriate reuse identifier string to the dequeueReusableAnnotationViewWithIdentifier: method of PWMapView.
 */
- (id)initWithFrame:(CGRect)frame annotation:(id<PWAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
