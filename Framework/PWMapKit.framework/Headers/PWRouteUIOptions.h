//
//  PWRouteOptions.h
//  PWMapKit
//
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>

/**
 * The colors and junction type for route path and route instruction paths.
 */
@interface PWRouteUIOptions : NSObject

/**
 * The stroke color to use for route path.
 */
@property (nonatomic) UIColor *routeStrokeColor;

/**
 * The fill color to use for route instruction path.
 */
@property (nonatomic) UIColor *instructionFillColor;

/**
 * The stroke color to use for route instruction path.
 */
@property (nonatomic) UIColor *instructionStrokeColor;

/**
 * The fill color to use for route direction path. The default color is white.
 */
@property (nonatomic) UIColor *directionFillColor;

/**
 * The stroke color to use for route direction path. The default color is the same as `routeFillColor`.
 */
@property (nonatomic) UIColor *directionStrokeColor;

/**
 * Whether or not to show line join point. Default value is false.
 */
@property (nonatomic) BOOL showJoinPoint;

/**
 * The color to use for the line join point when `showJoinPoint` is true.
 */
@property (nonatomic) UIColor *joinPointColor;

/**
 * Junction types for the lines.
 */
@property (nonatomic) CGLineJoin lineJoin;

@end
