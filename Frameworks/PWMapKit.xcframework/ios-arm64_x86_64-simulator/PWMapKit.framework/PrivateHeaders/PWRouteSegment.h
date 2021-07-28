//
//  PWRouteSegment.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWMappingTypes.h"

/**
 The indoor map object encompasses a wide variety of route segments. Each segment contain segment ID, start point and end point.
 */

@interface PWRouteSegment : NSObject

/**
 The floor identifier. (read-only)
 */
@property (readonly) NSInteger floorID;

/**
 The starting point of the segment. (read-only)
 */
@property (readonly) PWAnnotationIdentifier startPointID;

/**
 The end point of the segment. (read-only)
 */
@property (readonly) PWAnnotationIdentifier endPointID;

/**
 The distance of the segment. (read-only)
 */
@property (readonly) CLLocationDistance distance;

@end
