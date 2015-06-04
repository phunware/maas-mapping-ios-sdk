//
//  PWRouteOverlayRenderer.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

@class PWRouteOverlay;
@class PWBuildingOverlay;
@class PWMapView;

/**
 The PWRouteOverlayRenderer class defines the basic behavior for drawing a route-based overlay. The renderer draws the visual representation of a `PWRouteStep` object.
 */
@interface PWRouteOverlayRenderer : MKOverlayPathRenderer

/**
 The polyline that the overlay renderer is currently drawing. (read-only)
 */
@property (nonatomic, readonly) MKPolyline *polyline;

/**
 Initializes and returns the route overlay renderer and associates it with the specified route overlay object.
 @param overlay The route overlay to initialize the renderer with. The route overlay contains several important pieces of information the route renderer needs to draw the route.
 @param buildingOverlay The building overlay to initiatize the renderer with. The route overlay communicates with the building overlay to switch floors if necessary.
 @param buildingOverlay The building overlay to initiatize the renderer with. The route overlay communicates with the building overlay to switch floors if necessary.
  @param mapView The mapView to initiatize the renderer with. The mapView is needed for the renderer to know the current zoom workaround state.
 @return A basic route overlay renderer.
 */
- (instancetype)initWithRouteOverlay:(PWRouteOverlay *)overlay buildingOverlay:(PWBuildingOverlay *)buildingOverlay mapView:(PWMapView*)mapView;

@end
