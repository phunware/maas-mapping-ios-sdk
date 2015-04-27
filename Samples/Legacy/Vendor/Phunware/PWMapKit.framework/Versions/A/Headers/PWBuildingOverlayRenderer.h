//
//  PWBuildingOverlayRenderer.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

@class PWMapView;

/**
 The PWBuildingOverlayRenderer class defines the basic behavior associated with all building-based overlays. An overlay renderer draws the visual representation of a `PWBuilding` object. This class defines the drawing infrastructure used by the map view.
 */
@interface PWBuildingOverlayRenderer : MKOverlayRenderer

/**
 In order to use the temporary zoom workaround feature, a building overlay renderer needs to have a weak link to the map view using the renderer.
 */
@property (weak) PWMapView *mapView;

@end
