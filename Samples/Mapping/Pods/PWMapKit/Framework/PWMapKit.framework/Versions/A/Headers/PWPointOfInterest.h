//
//  PWPointOfInterest.h
//  PWMapKit
//
//  Created by Steven Spry on 5/12/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "PWPointOfInterestType.h"
#import "PWFloor.h"

@class PWFloor;

/**
 *  A PWPointOfInterest represents single point of interest defined within MaaS Portal.
 */
@interface PWPointOfInterest : NSObject<MKAnnotation>

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  The identifier for the point of interest structure that corresponds to the MaaS Portal.
 */
@property (nonatomic,readonly) NSInteger identifier;

/**
 *  A summary description of the point of interest.
 */
@property (nonatomic,copy,readonly) NSString *summary;

/**
 *  The PWFloor object that the point of interest is a member of.
 */
@property (nonatomic,readonly,weak) PWFloor *floor;

/**
 *  The PWPointOfInterestType object that the point of interest is a member of.
 */
@property (nonatomic,copy,readonly) PWPointOfInterestType *pointOfInterestType;

/**
 *  The representative UIImage of the point of interest.
 */
@property (nonatomic,readonly) UIImage *image;

/**
 Metadata associated with the point of interest.
 */
@property (nonatomic,readonly) NSDictionary *metaData;

@end
