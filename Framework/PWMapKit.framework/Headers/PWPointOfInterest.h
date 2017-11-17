//
//  PWPointOfInterest.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWMapPoint.h"

@class PWFloor;
@class PWPointOfInterestType;

/**
 The building annotation object is a convenience class that implements the `PWPointOfInterest` protocol. This class it primarily for internal use and not exposed in the SDK.
 */
@interface PWPointOfInterest : NSObject <PWMapPoint>

/**
 *  A summary description of the point-of-interest.
 */
@property (nonatomic, readonly) NSString *summary;

/**
 *  The PWFloor object that the point-of-interest is a member of.
 */
@property (nonatomic, readonly, weak) PWFloor *floor;

/**
 *  The PWPointOfInterestType object that the point-of-interest is a member of.
 */
@property (nonatomic, readonly) PWPointOfInterestType *pointOfInterestType;

/**
 *  The representative UIImage of the point-of-interest.
 */
@property (nonatomic, readonly) UIImage *image;

/**
 *  The URL of the point-of-interest image.
 */
@property (nonatomic, readonly) NSURL *imageURL;

/**
 * Metadata associated with the point-of-interest.
 */
@property (nonatomic, readonly) NSDictionary *metaData;

/**
 * The title of the Point of Interest.
 */
@property (nonatomic, copy, readwrite) NSString *title;

/**
 * The subtitle of the Point of Interest.
 */
@property (nonatomic, copy, readwrite) NSString *subtitle;

@end
