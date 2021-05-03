//
//  PWRoutePolygon.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 9/17/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "PWRouteOverlayProtocol.h"

@interface PWRoutePolygon : MKPolygon<PWRouteOverlayProtocol, NSCopying>

@property (nonatomic) BOOL stroke;

+ (void)coordinatesFromPoints:(NSArray<id<PWMapPoint>> *)points to:(CLLocationCoordinate2D *)coordinates;

@end
