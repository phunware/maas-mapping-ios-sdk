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
@property (readonly) NSString *summary;

/**
 *  The PWFloor object that the point-of-interest is a member of.
 */
@property (readonly, weak) PWFloor *floor;

/**
 *  The PWPointOfInterestType object that the point-of-interest is a member of.
 */
@property (readonly) PWPointOfInterestType *pointOfInterestType;

/**
 *  The representative UIImage of the point-of-interest.
 */
@property (readonly) UIImage *image;

/**
 * Metadata associated with the point-of-interest.
 */
@property (readonly) NSDictionary *metaData;

@end
