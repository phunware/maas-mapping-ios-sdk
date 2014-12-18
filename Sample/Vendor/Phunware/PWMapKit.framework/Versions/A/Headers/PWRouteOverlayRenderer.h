//
//  PWRouteOverlayRenderer.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>

@class PWRouteOverlay;

/**
 The PWRouteOverlayRenderer class defines the basic behavior for drawing a route-based overlay. The renderer draws the visual representation of `PWRouteStep` object.
 */
@interface PWRouteOverlayRenderer : MKOverlayPathRenderer

/**
 The polyline that the overlay renderer is currently drawing. (read-only)
 */
@property (nonatomic, readonly) MKPolyline *polyline;

/**
 Initializes and returns the route overlay renderer and associates it with the specified route overlay object.
 @param overlay The route overlay to initialize the renderer with. The route overlay contains several important pieces of information the route renderer needs to draw the route.
 @return A basic route overlay renderer.
 */
- (instancetype)initWithRouteOverlay:(PWRouteOverlay *)overlay;

@end
