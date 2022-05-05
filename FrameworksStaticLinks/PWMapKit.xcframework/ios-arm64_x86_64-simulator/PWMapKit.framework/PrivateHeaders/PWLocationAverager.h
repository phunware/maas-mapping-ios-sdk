//
//  PWLocationAverager.h
//  PWMapKit
//
//  Created by Sam Odom on 11/24/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWIndoorLocation;

@interface PWLocationAverager : NSObject

@property (readonly) NSTimeInterval maximumAge;
@property (readonly) PWIndoorLocation *averageLocation;

- (instancetype)initWithMaximumAge:(NSTimeInterval)maximumAge;

- (void)addLocation:(PWIndoorLocation*)location;
- (void)clearLocations;

@end
