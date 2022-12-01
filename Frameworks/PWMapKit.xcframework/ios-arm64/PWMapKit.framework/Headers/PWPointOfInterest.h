//
//  PWPointOfInterest.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWMapPoint.h"

@class PWFloor;
@class PWPointOfInterestType;

NS_ASSUME_NONNULL_BEGIN

/**
 This class represents a point-of-interest defined on the MaaS portal and contains data associated with that point-of-interest.
 */
@interface PWPointOfInterest : NSObject <PWMapPoint>

/**
 *  A description of the point-of-interest. May be NULL.
 */
@property (nonatomic, readonly, nullable) NSString *summary;

/**
 *  The `PWFloor` object that the point-of-interest belongs to.
 */
@property (nonatomic, readonly, weak, nullable) PWFloor *floor;

/**
 *  The `PWPointOfInterestType` object that the point-of-interest is a member of.
 */
@property (nonatomic, readonly, nullable) PWPointOfInterestType *pointOfInterestType;

/**
 *  The representative UIImage of the point-of-interest. Will be NULL if image has not yet been loaded.
 */
@property (nonatomic, readonly, nullable) UIImage *image;

/**
 *  The URL of the point-of-interest image. May be NULL if using custom POI image loading.
 */
@property (nonatomic, readonly, nullable) NSURL *imageURL;

/**
 * Metadata associated with the point-of-interest. May be NULL.
 */
@property (nonatomic, readonly, nullable) NSDictionary<NSString*, id> *metaData;

/**
 * The minimum zoom level that the point-of-interest is visible on, and the below are the possible values:
 * -1 - always visible.
 * 1 - subtract 4 from the maximum zoom level that current iOS map supports, it's 18.
 * 2 - subtract 3 from the maximum zoom level that current iOS map supports, it's 19.
 * 3 - subtract 2 from the maximum zoom level that current iOS map supports, it's 20.
 * 4 - subtract 1 from the maximum zoom level that current iOS map supports, it's 21.
 * 5 - the maximum zoom level that current iOS map supports, it's 22.
 *
 * @discussion The point-of-interest is only visble when the map zoom level is between `minZoomLevel` and `maxZoomLevel`.
 */
@property (nonatomic, readonly) NSInteger minZoomLevel;

/**
 * The maximum zoom level that the point-of-interest is visible on, and the below are the possible values:
 * -1 - always visible.
 * 1 - subtract 4 from the maximum zoom level that current iOS map supports, it's 18.
 * 2 - subtract 3 from the maximum zoom level that current iOS map supports, it's 19.
 * 3 - subtract 2 from the maximum zoom level that current iOS map supports, it's 20.
 * 4 - subtract 1 from the maximum zoom level that current iOS map supports, it's 21.
 * 5 - the maximum zoom level that current iOS map supports, it's 22.
 *
 * @discussion The point-of-interest is only visble when the map zoom level is between `minZoomLevel` and `maxZoomLevel`.
 */
@property (nonatomic, readonly) NSInteger maxZoomLevel;

/**
 * The title of the point-of-interest. May be NULL.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *title;

/**
 * The subtitle of the point-of-interest. May be NULL.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *subtitle;

/**
 * The portal identifier of the point-of-interest. May be NULL.
 */
@property (readonly, nullable) NSString *portalID;

@end

NS_ASSUME_NONNULL_END
