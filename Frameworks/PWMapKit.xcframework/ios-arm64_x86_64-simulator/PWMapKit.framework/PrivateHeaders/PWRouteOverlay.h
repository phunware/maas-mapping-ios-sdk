//
//  PWRouteOverlay.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 9/7/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "PWRouteOverlayProtocol.h"

@interface PWRouteOverlay : MKPolyline<PWRouteOverlayProtocol>

@property (nonatomic, readonly) PWRouteStep *routeStep;

@end
