//
//  PWDirectionsWaypointProtocol.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWMappingTypes.h"


/**
 `PWDirectionsWaypointProtocol` represents a start, intermediate or end point in a directions request.
 */
@protocol PWDirectionsWaypointProtocol <NSObject>


/**
 The geographic location of the waypoint.
 */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


/**
 The identifier associated with the floor of the waypoint.
 */
@property (nonatomic, readonly) PWBuildingFloorIdentifier floorID;


@end
