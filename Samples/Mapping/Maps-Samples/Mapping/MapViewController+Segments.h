//
//  MapViewController+Segment.h
//  PWMapKit
//
//  Created on 9/6/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MapViewController+Private.h"

@interface MapViewController(Segments)

- (void)setupSegments;

- (void)setDirectorySegments;

- (void)setRouteSegments;

- (void)hideSegments:(BOOL)hide;

- (void)selectSegmentFor:(DirectorySegments)segment;

@end
