//
//  PWPointOfInterestInfo.h
//  PWMapKit
//
//  Created by Aaron Pendley on 3/12/20.
//  Copyright © 2020 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWPointOfInterestType;

NS_ASSUME_NONNULL_BEGIN

/**
An object encapsulating information about a PointOfInterest
*/
@interface PWPointOfInterestInfo : NSObject

/**
 The point identifier as specified by the mapping service.
 */
@property (nonatomic, readonly) NSInteger identifier;

/**
 *  The `PWPointOfInterestType` object that the point-of-interest is a member of.
 */
@property (nonatomic, readonly) PWPointOfInterestType *pointOfInterestType;

/**
 * Metadata associated with this point.
 */
@property (nonatomic, readonly, nullable) NSDictionary *metaData;

/**
 * Default initializer not available
 */
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
