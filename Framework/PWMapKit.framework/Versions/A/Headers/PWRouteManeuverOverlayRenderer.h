//
//  PWRouteManeuverOverlayRenderer.h
//  PWMapKit
//
//  Created by Sam Odom on 4/14/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

@class PWMapView;

/**
 The `PWRouteManeuverOverlayRenderer` class draws a map overlay whose shape is represented by the current maneuver for a route.
 
 You can use this class as-is or subclass to define additional drawing behaviors. If you subclass, you should override the createPath method and use that method to build the appropriate path object. To change the path, invalidate it and recreate the path using whatever new data your subclass has obtained.
 */
@interface PWRouteManeuverOverlayRenderer : MKOverlayPathRenderer

/**
 Initializes and returns the route overlay renderer and associates it with the specified route overlay object.
 @param overlay The route maneuver overlay to initialize the renderer with. The route overlay contains several important pieces of information the route maneuver renderer needs to draw the route.
 @param mapView The mapView to initiatize the renderer with. The mapView is needed for the renderer to know the current zoom workaround state.
 @return A basic route manuever overlay renderer.
 */
- (instancetype)initWithOverlay:(id <MKOverlay>)overlay andMapView:(PWMapView*)mapView;

@end
