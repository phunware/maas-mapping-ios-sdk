//
//  PWMapView+ZoomLevel.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 12/01/2017.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import "PWMapView+Private.h"

@interface PWMapView (ZoomLevel)

- (void)calculateZoomLevel;

- (void)updateZoomLevel:(double)zoomSacle;

@end
