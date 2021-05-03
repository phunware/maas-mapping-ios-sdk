//
//  PWMapView+Building.h
//  PWMapKit
//
//  Created by Sam Odom on 10/10/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWMapView+Private.h"

@interface PWMapView (Building)

- (void)resetMapView;
- (void)loadInitialFloorWithAnimation:(BOOL)animation;
- (void)setCurrentFloorById:(NSInteger)floorId;

@end
