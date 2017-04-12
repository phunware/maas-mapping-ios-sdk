//
//  PWCustomPointOfInterest.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 07/03/2017.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWPointOfInterestType.h"
#import "PWPointOfInterest.h"

/**
 *  A PWCustomPointOfInterest represents custom single point of interest.
 */
@interface PWCustomPointOfInterest : PWPointOfInterest

/**
 *  The PWPointOfInterestType object that the point of interest is a member of.
 */
@property (nonatomic, copy) PWPointOfInterestType * __nullable pointOfInterestType;

/**
 Metadata associated with the custom point of interest.
 */
@property (nonatomic, strong) NSDictionary * __nullable metaData;

/** 
 A flag indicating whether it's to display or hide the text label.
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
 * Disable the default initializer.
 */
- (instancetype __nullable)init __unavailable;

/**
 *  Instantiates a PWCustomLocation object with the given parameters.
 *
 *  @param coordinate The coordinate of custom point of interest
 *  @param floorId The floor identifier of custom point of interest
 *  @param buildingId The building identifier of custom point of interest
 *  @param title The text title of custom point of interest
 *  @param image The icon of custom point of interest
 *
 *  @return Returns a PWCustomLocation object.
 */
- (instancetype __nullable)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                           floorId:(NSInteger)floorId
                        buildingId:(NSInteger)buildingId
                             title:(NSString * __nullable)title
                             image:(UIImage * __nullable)image;

@end
