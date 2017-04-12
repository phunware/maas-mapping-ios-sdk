//
//  PWMapPoint.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 21/02/2017.
//  Copyright © 2017 Phunware. All rights reserved.
//

@protocol MKAnnotation;

@protocol PWMapPoint <MKAnnotation>

/**
 The point identifier as specified by the mapping service.
 */
@property (nonatomic, readonly) NSInteger identifier;

/**
 The floor identifier for which this point applies.
 */
@property (nonatomic, readonly) NSInteger floorID;

/**
 The building identifier for which this point applies.
 */
@property (nonatomic, readonly) NSInteger buildingID;

/**
 A flag indicating whether it's an accessible point.
 */
@property (nonatomic, readonly, getter=isAccessible) BOOL accessible;

/**
 A flag indicating whether the point is friendly to the visually-impaired.
 */
@property (nonatomic, readonly, getter=isVisualImpaired) BOOL visualImpaired;

/**
 A flag indicating whether it's an exit point.
 */
@property (nonatomic, readonly, getter=isExit) BOOL exit;

@end
