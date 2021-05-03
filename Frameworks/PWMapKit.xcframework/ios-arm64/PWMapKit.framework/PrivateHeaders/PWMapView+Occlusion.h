//
//  PWMapView+POIOcclusion.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 09/02/2017.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import "PWMapView+Private.h"

@interface PWMapView (Occlusion)

- (void)occlusion;
- (void)updateAnnotationLabels:(BOOL)forcible;

@end
