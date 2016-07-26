//
//  PWCustomLocation.h
//  PWMapKit
//
//  Created by Steven Spry on 6/3/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWPointOfInterest.h"
#import "PWFloor.h"

@class PWFloor;

/**
 *  Defines the different type of custom locations
 */
typedef NS_ENUM(NSUInteger, PWCustomLocationType) {
    /**
     *  Represents custom location type for current location.
     */
    PWCustomLocationTypeCurrentLocation,
    /**
     *  Represents custom location type for dropped ping location.
     */
    PWCustomLocationTypeDroppedPin
};

/**
 *  A PWCustomLocation extends from PWPointOfInterest and represents single location point. PWCustomLocation Can represent user's current location or a user's dropped pin.
 */
@interface PWCustomLocation : PWPointOfInterest

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  The type of custom location the instance of PWCustomLocation represents
 */
@property (nonatomic) PWCustomLocationType locationType;

/**---------------------------------------------------------------------------------------
 * @name Instance Methods
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Instantiates a PWCustomLocation object with the given latitude and longitude parameters.
 *
 *  @param latitude  A double value to represent the latitude of a custom location
 *  @param longitude A double value to represent the longitude of a custom location
 *
 *  @return Returns a PWCustomLocation object.
 */
- (instancetype) initWithLatitude:(double) latitude longitude:(double) longitude;


@end
