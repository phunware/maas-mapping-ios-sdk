//
//  PWRoutePolygon.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 9/17/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "PWRouteStep.h"
#import "PWRouteInstruction.h"

#define kArrowEdgeLength 5.0
#define kArrowHeadHalfAngle 30.0

@protocol PWRouteOverlayProtocol

@optional
+ (instancetype)polylineWithRouteStep:(PWRouteStep *)step;

+ (instancetype)polygonWithInstruction:(PWRouteInstruction *)instruction;
+ (NSArray<id<PWMapPoint>> *)preparePoints:(PWRouteInstruction *)instruction;

@end
