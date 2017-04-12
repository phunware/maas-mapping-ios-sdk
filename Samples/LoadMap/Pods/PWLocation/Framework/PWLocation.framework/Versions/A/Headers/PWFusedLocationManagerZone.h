//
//  PWFusedLocationManagerZone.h
//  PWLocation
//
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/**
 The 'PWFusedLocationManagerZone' class defines a zone where a particular location manager should be used. The zone will be considered valid for use only if the location given by the location manager has a coordinate inside the polygon region and if the floorID of the location is contained in the floorIDs array.
 */
@interface PWFusedLocationManagerZone : NSObject

/** The polygon that encompasses the zone where the location manager should be used */
@property (readonly) MKPolygon *polygon;
/** The identifiers of the floors where the polygon for this zone is be valid */
@property (readonly) NSArray /* NSNumber */ *floorIdentifiers;

/**
 Initializes a zone where a location manager should be used.
 @param polygon A polygon that encompasses the zone where the location manager should be used
 @param floorIdentifiers An array of integers that indicate the floors where the polygon for this zone is be valid
 @return An initialized zone object.
 */
- (instancetype)initWithPolygon:(MKPolygon *)polygon floorIdentifiers:(NSArray /* NSNumber */ *)floorIdentifiers NS_DESIGNATED_INITIALIZER;

@end
