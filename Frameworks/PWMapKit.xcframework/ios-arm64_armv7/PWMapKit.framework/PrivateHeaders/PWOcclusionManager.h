//
//  PWOcclusionManager.h
//  PWMapKit
//
//  Created by Illya Busigin on 8/6/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWMapView;

@interface PWOcclusionManager : NSObject

- (instancetype)initWithMapView:(PWMapView *)mapView;

- (void)update;

@end
