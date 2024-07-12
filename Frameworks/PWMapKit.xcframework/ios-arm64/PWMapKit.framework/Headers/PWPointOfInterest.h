//
//  PWPointOfInterest.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapPoint.h>

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
 * 1 - subtract 8 from the maximum zoom level that current iOS map supports, it's 12.
 * 2 - subtract 6 from the maximum zoom level that current iOS map supports, it's 14.
 * 3 - subtract 4 from the maximum zoom level that current iOS map supports, it's 16.
 * 4 - subtract 2 from the maximum zoom level that current iOS map supports, it's 18.
 * 5 - the maximum zoom level that current iOS map supports, it's 20.
 *
 * @discussion The point-of-interest is only visble when the map zoom level is between `minZoomLevel` and `maxZoomLevel`.
 */
@property (nonatomic, readonly) NSInteger minZoomLevel;

/**
 * The maximum zoom level that the point-of-interest is visible on, and the below are the possible values:
 * -1 - always visible.
 * 1 - subtract 8 from the maximum zoom level that current iOS map supports, it's 12.
 * 2 - subtract 6 from the maximum zoom level that current iOS map supports, it's 14.
 * 3 - subtract 4 from the maximum zoom level that current iOS map supports, it's 16.
 * 4 - subtract 2 from the maximum zoom level that current iOS map supports, it's 18.
 * 5 - the maximum zoom level that current iOS map supports, it's 20.
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

/**
 * Determines whether or not the point-of-interest can participate in routes.
 */
@property (nonatomic, getter=isRoutable, readonly) BOOL routable;

@end

NS_ASSUME_NONNULL_END
