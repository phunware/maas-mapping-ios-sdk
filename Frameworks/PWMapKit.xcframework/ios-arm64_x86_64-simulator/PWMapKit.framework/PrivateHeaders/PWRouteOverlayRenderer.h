//
//  PWRouteOverlayRenderer.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 9/7/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "PWRouteUIOptions.h"

/**
 The PWRouteOverlayRenderer class defines the basic behavior for drawing a route-based overlay. The renderer draws the visual representation of a `PWRouteStep` object.
 */
@interface PWRouteOverlayRenderer : MKPolylineRenderer

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay ui:(PWRouteUIOptions *)options;

@end
