//
//  PWRouteInstructionRenderer.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 9/7/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "PWRouteUIOptions.h"

@interface PWRouteInstructionRenderer : MKPolygonRenderer

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay ui:(PWRouteUIOptions *)options;

@end
