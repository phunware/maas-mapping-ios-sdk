//
//  PWCustomLocation.h
//  PWMapKit
//
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PWMapPoint.h"

@protocol PWMapPoint;

/**
 * An annotation which represents a user's dropped pin.
 * @discussion Please use `PWUserLocation` instead.
 */
__attribute__ ((deprecated))
@interface PWCustomLocation : NSObject <PWMapPoint>

/**
 Center latitude and longitude of this annotation.
 */
@property (nonatomic) CLLocationCoordinate2D coordinate;

/**
 The identifier of this annotation.
 */
@property (nonatomic) NSInteger identifier;

/**
 The MaaS identifier of the floor the custom location is on.
 */
@property (nonatomic) NSInteger floorID;

/**
 The MaaS identifier of the building the custom location is in.
 */
@property (nonatomic) NSInteger buildingID;

/**
 The name of the this annotation.
 */
@property (nonatomic, copy, nullable) NSString *title;

/**
 *  Instantiates a `PWCustomLocation` object with the given properties.
 *
 *  @param coordinate   The lat, long position of the custom location
 *  @param identifier   Integer to help the developer identify the custom location
 *  @param floorId      The MaaS identifier of the floor the custom location is on
 *  @param buildingId   The MaaS identifier of the building the custom location is in
 *  @param title        The name of the custom location
 *
 *  @return Returns a `PWCustomLocation` object, or nil if the given coordinate is invalid.
 */
- (instancetype __nullable)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                                   identifier:(NSInteger)identifier
                                      floorId:(NSInteger)floorId
                                   buildingId:(NSInteger)buildingId
                                        title:(NSString* __nullable)title;

@end
