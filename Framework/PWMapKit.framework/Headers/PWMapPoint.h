//
//  PWMapPoint.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 21/02/2017.
//  Copyright © 2017 Phunware. All rights reserved.
//

@protocol MKAnnotation;

/**
 * A protocol for associating your content with a specific indoor map location.
 */
@protocol PWMapPoint <MKAnnotation>

/**
 The point identifier as specified by the mapping service.
 */
@property (nonatomic, readonly) NSInteger identifier;

/**
 The identifier of the floor this point belongs to.
 */
@property (nonatomic, readonly) NSInteger floorID;

/**
 The identifier of the building this point belongs to.
 */
@property (nonatomic, readonly) NSInteger buildingID;

@optional

/**
 A flag indicating if it's an accessible point.
 */
@property (nonatomic, readonly, getter=isAccessible) BOOL accessible;

/**
 A flag indicating if the point is friendly to the visually-impaired.
 */
@property (nonatomic, readonly, getter=isVisualImpaired) BOOL visualImpaired;

/**
 A flag indicating if it's an exit point.
 */
@property (nonatomic, readonly, getter=isExit) BOOL exit;

/**
 * Metadata associated with this point.
 */
@property (nonatomic, readonly, nullable) NSDictionary *metaData;

@end
