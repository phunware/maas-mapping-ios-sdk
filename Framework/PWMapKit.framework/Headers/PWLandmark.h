//
//  PWLandmark.h
//  PWMapKit
//
//  Created by Aaron Pendley on 10/11/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWLandmarkType.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWLandmark : NSObject

/**
 * Type of landmark represented by this config
 */
@property (nonatomic, assign) PWLandmarkType landmarkType;

/**
 * Landmark name for route instructions
 */
@property (nonatomic, readonly, copy) NSString* name;

/**
 * Postiion of turn relative to landmark
 */
@property (nonatomic, readonly, assign) PWLandmarkPosition position;

/**
 * Distance to this landmark from the beginning of the maneuver
 */
@property (nonatomic, readonly, assign) CLLocationDistance distance;

/**
 * Default initializer not available
 */
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
