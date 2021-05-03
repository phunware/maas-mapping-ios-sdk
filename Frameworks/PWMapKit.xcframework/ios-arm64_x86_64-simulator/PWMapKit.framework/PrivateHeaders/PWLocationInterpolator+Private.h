//
//  PWLocationInterpolator+Private.h
//  PWMapKit
//
//  Created by Sam Odom on 12/29/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWLocationInterpolator.h"

#import "PWCoordinateInterpolationSegment.h"

@class PWObjectQueue;

@interface PWLocationInterpolator ()

@property (readonly) PWObjectQueue *locationQueue;
@property NSInteger floorID;
@property PWCoordinateInterpolationSegment *currentSegment;

@end
