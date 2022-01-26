//
//  PWMapView+ZoomWorkaround.h
//  PWMapKit
//
//  Created by Sam Odom on 11/3/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWMapView+Private.h"

@interface PWMapView (ZoomWorkaround)

- (BOOL)hasReachedMaxZooming;
- (void)zoomWorkaround;

@end
