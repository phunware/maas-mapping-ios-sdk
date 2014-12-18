//
//  PWSVPulsingAnnotationView.h
//
//  Created by Sam Vermette on 01.03.13.
//  https://github.com/samvermette/SVPulsingAnnotationView
//

#import <MapKit/MapKit.h>

/**
 A customizable `MKUserLocationView` replica for your iOS app created by Sam Vernette, prefixed to avoid namespace collisions. This view can be used for displaying the users location on the map.
 */

@interface PWSVPulsingAnnotationView : MKAnnotationView

/**
 The annotation color. 
 @discussion The default is the same as Apple's `MKUserLocationView`.
 */
@property (nonatomic, strong) UIColor *annotationColor; // default is same as MKUserLocationView

/**
 The pulse color.
 @discussion The default is the same as annotationColor.
 */
@property (nonatomic, strong) UIColor *pulseColor;

/**
 The image associated with the annotation view. 
 @discussion The default is `nil`.
 */
@property (nonatomic, strong) UIImage *image;

/**
 The pulse scale factor.
 @discussion The default is 5.3.
 */
@property (nonatomic, readwrite) float pulseScaleFactor;

/**
 The pulse animation duration.
 @discussion The default is 1 second.
 */
@property (nonatomic, readwrite) NSTimeInterval pulseAnimationDuration;

/**
 The outer purlse animation duration.
 @discussion The default is 3 seconds.
 */
@property (nonatomic, readwrite) NSTimeInterval outerPulseAnimationDuration;

/**
 The delay between pulse cycles.
 @discussion The default is 1 second.
 */
@property (nonatomic, readwrite) NSTimeInterval delayBetweenPulseCycles; // default is 1s

@end
