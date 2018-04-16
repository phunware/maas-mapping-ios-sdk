//
//  PWCustomPointOfInterest.h
//  PWMapKit
//
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "PWMapPoint.h"
@class PWPointOfInterestType;
@class PWFloor;

/**
 *  A PWCustomPointOfInterest represents custom single point-of-interest.
 */
@interface PWCustomPointOfInterest : NSObject <PWMapPoint>

/**
 The point identifier as specified by the mapping service.
 */
@property (nonatomic) CLLocationCoordinate2D coordinate;

/**
 The point identifier as specified by the mapping service.
 */
@property (nonatomic) NSInteger identifier;

/**
 The floor identifier for which this point applies.
 */
@property (nonatomic) NSInteger floorID;

/**
 The floor for which this point applies.
 */
@property (nonatomic, nullable) PWFloor *floor;

/**
 The building identifier for which this point applies.
 */
@property (nonatomic) NSInteger buildingID;

/**
 *  The title of the point-of-interest.
 */
@property (nonatomic, copy, nullable) NSString *title;

/**
 *  A summary description of the point-of-interest.
 */
@property (nonatomic, copy, nullable) NSString *summary;

/**
 *  The representative UIImage of the point-of-interest.
 */
@property (nonatomic, nullable) UIImage *image;

/**
 *  A `PWPointOfInterestType` object that this custom point-of-interest is a member of, a type image icon will automatically be applied if `image` property is not set.
 */
@property (nonatomic, nullable) PWPointOfInterestType *pointOfInterestType;

/**
 Metadata associated with the custom point-of-interest, using it to pass data as you want.
 */
@property (nonatomic, nullable) NSDictionary *metaData;

/** 
 A flag indicating whether it's to display or hide the label text.
 */
@property (nonatomic, getter=isShowTextLabel) BOOL showTextLabel;

/**
 A flag indicating whether it's an accessible point.
 */
@property (nonatomic, getter=isAccessible) BOOL accessible;

/**
 A flag indicating whether the point is friendly to the visually-impaired.
 */
@property (nonatomic, getter=isVisualImpaired) BOOL visualImpaired;

/**
 A flag indicating whether it's an exit point.
 */
@property (nonatomic, getter=isExit) BOOL exit;
/**
 * The minimum zoom level that the point-of-interest is visible on, and the below are the possible values:
 * -1 - always visible(the default value).
 * 1 - subtract 4 from the maximum zoom level that current iOS map supports, it's 18.
 * 2 - subtract 3 from the maximum zoom level that current iOS map supports, it's 19.
 * 3 - subtract 2 from the maximum zoom level that current iOS map supports, it's 20.
 * 4 - subtract 1 from the maximum zoom level that current iOS map supports, it's 21.
 * 5 - the maximum zoom level that current iOS map supports, it's 22.
 *
 * @discussion The point-of-interest is only visble when the map zoom level is between `minZoomLevel` and `maxZoomLevel`, it's `-1` by default.
 */
@property (nonatomic) NSInteger minZoomLevel;

/**
 * The maximum zoom level that the point-of-interest is visible on, and the below are the possible values:
 * -1 - always visible(the default value).
 * 1 - subtract 4 from the maximum zoom level that current iOS map supports, it's 18.
 * 2 - subtract 3 from the maximum zoom level that current iOS map supports, it's 19.
 * 3 - subtract 2 from the maximum zoom level that current iOS map supports, it's 20.
 * 4 - subtract 1 from the maximum zoom level that current iOS map supports, it's 21.
 * 5 - the maximum zoom level that current iOS map supports, it's 22.
 *
 * @discussion The point-of-interest is only visble when the map zoom level is between `minZoomLevel` and `maxZoomLevel`, it's `-1` by default.
 */
@property (nonatomic) NSInteger maxZoomLevel;

/**
 *  Instantiates a `PWCustomPointOfInterest` object with the given parameters.
 *
 *  @param coordinate The coordinate of custom point-of-interest.
 *  @param floorId The floor identifier the custom point-of-interest on.
 *  @param buildingId The building identifier the custom point-of-interest in.
 *  @param title The title of custom point-of-interest.
 *  @param image The icon of custom point-of-interest.
 *
 *  @return Returns a `PWCustomPointOfInterest` object.
 */
- (instancetype __nullable)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                           floorId:(NSInteger)floorId
                        buildingId:(NSInteger)buildingId
                             title:(NSString * __nullable)title
                             image:(UIImage * __nullable)image;

@end
