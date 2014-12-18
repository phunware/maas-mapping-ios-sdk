//
//  PWLocationProtocol.h
//  PWLocation
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

static const NSInteger kPWUnknownFloorID = NSNotFound;

/**
 The `PWLocation` is an abstract protocol that defines an indoor location. This protocol is primarily used for directions and for displaying the user's location on an indoor map.
 */
@protocol PWLocation <NSObject>

/**
 The geographical coordinate information. (read-only)
 */
@property (readonly) CLLocationCoordinate2D coordinate;

/**
 The radius of uncertainty for the location, in meters. (read-only)
 @discussion The location’s latitude and longitude identify the center of the circle, this value would indicate the radius of that circle. A value of -1 indicates that the location’s latitude and longitude are invalid.
 */
@property (readonly) CLLocationAccuracy horizontalAccuracy;

/**
 The floor ID associated with the location. 
 @discussion If the location is outdoors, this value should be `kPWUnknownFloorID`. (read-only)
 */
@property (readonly) NSInteger floorID;
    
@end
