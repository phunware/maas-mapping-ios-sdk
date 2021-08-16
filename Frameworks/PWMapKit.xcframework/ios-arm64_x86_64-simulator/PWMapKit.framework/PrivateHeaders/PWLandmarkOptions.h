//
//  PWLandmarkOptions.h
//  PWMapKit
//
//  Created by Aaron Pendley on 10/8/19.
//  Copyright © 2019 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWLandmarkType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PWMapPoint;

extern const NSInteger PWLandmarkOptionsInvalidAssociatedLandmarkIdentifier;

@interface PWLandmarkOptions : NSObject

/**
 * Type of landmark represented by this config
 */
@property (nonatomic, assign) PWLandmarkType landmarkType;

/**
 * Only valid if 'landmarkType' is "PWLandmarkTypeLandmark". Nil otherwise.
 */
@property (nonatomic, copy, nullable) NSString* landmarkName;

/**
 * If 'landmarkType' is "PWLandmarkTypeAssociatedLandmark", contains a landmark point identifier. Otherwise, contains the value PWLandmarkOptionsInvalidAssociatedLandmarkIdentifier.
 */
@property (nonatomic, assign) NSInteger associatedLandmarkIdentifier;

/**
 * Default initializer not available
 */
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 * Create a PWLandmarkOptions with "PWLandmarkTypeLandmark" type
 */
- (instancetype)initWithName:(NSString*) name NS_DESIGNATED_INITIALIZER;;

/**
 * Create a PWLandmarkOptions with "PWLandmarkTypeAssociatedLandmark" type
 */
- (instancetype)initWithAssociatedLandmarkIdentifier:(NSInteger)associatedLandmarkIdentifier NS_DESIGNATED_INITIALIZER;;

/**
 * Create a PWLandmarkOptions from a PWMapPoint
 */
+ (nullable instancetype)createWithMapPoint:(id<PWMapPoint>)mapPoint;

@end

NS_ASSUME_NONNULL_END
