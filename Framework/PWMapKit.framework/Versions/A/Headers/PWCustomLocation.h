//
//  PWCustomLocation.h
//  PWMapKit
//
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWMapPoint.h"

/**
 *  Defines the different types of custom locations
 */
typedef NS_ENUM(NSUInteger, PWCustomLocationType) {
    /**
     *  Represents custom location type for current location.
     */
    PWCustomLocationTypeCurrentLocation,
    /**
     *  Represents custom location type for dropped pin location.
     */
    PWCustomLocationTypeDroppedPin
} __deprecated;

/**
 *  A PWCustomLocation extends from PWPointOfInterest and represents single location point. PWCustomLocation can represent user's current location or a user's dropped pin.
 */
@interface PWCustomLocation : NSObject<PWMapPoint>

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  The type of custom location the instance of PWCustomLocation represents.
 */
@property (nonatomic) PWCustomLocationType locationType __deprecated;

/**---------------------------------------------------------------------------------------
 * @name Instance Methods
 *  ---------------------------------------------------------------------------------------
 */

- (instancetype __nonnull)init __unavailable;

/**
 *  Instantiates a PWCustomLocation object with the given properties.
 *
 *  @param coordinate   The lat, long position of the custom location
 *  @param identifier   Integer to help the developer identify the custom location
 *  @param floorId      The MaaS identifier of the floor the custom location is on
 *  @param buildingId   The MaaS identifier of the building the custom location is in
 *  @param title        The name of the custom location
 *
 *  @return Returns a PWCustomLocation object, or nil if the given coordinate is invalid.
 */
- (instancetype __nullable)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                                   identifier:(NSInteger)identifier
                                      floorId:(NSInteger)floorId
                                   buildingId:(NSInteger)buildingId
                                        title:(NSString* __nullable)title;

/**
 *  Instantiates a PWCustomLocation object with the given latitude and longitude parameters.
 *
 *  @param latitude  A double value to represent the latitude of a custom location
 *  @param longitude A double value to represent the longitude of a custom location
 *
 *  @return Returns a PWCustomLocation object.
 */
- (instancetype __nullable)initWithLatitude:(double) latitude longitude:(double) longitude __deprecated;

@end
