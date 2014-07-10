//
//  PWLocationProtocol.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

static const NSInteger kPWUnknownFloorID = -1;

/**
 `PWLocationType` is the type of location.
 */
typedef NS_ENUM(NSInteger, PWLocationType) {
    /** The location type is unknown. */
    PWLocationTypeUnknown = -1,
    /** The location type is indoors. */
    PWLocationTypeIndoor,
    /** The location type is outdoors. */
    PWLocationTypeOutdoor
};

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
 @discussion The location’s latitude and longitude identify the center of the circle, this value would indicate the radius of that circle. A negative value indicates that the location’s latitude and longitude are invalid.
 */
@property (readonly) CLLocationAccuracy horizontalAccuracy;

/**
 The location type. Typically indoors or outdoors. (read-only)
 */
@property (readonly) PWLocationType type;

/**
 The floor ID associated with the location. 
 @discussion If the location is outdoors, this value should be `kPWUnknownFloorID`. (read-only)
 */
@property (readonly) NSInteger floorID;
    
@end
