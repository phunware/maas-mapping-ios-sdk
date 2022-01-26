//
//  PWLocationInterpolator.h
//  PWMapKit
//
//  Created by Sam Odom on 12/29/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

@class PWIndoorLocation;

@interface PWLocationInterpolator : NSObject

@property NSTimeInterval maximumInterval;

@property (readonly) PWIndoorLocation *location;

- (void)enqueueLocation:(PWIndoorLocation*)location;
- (void)clearLocations;

@end
