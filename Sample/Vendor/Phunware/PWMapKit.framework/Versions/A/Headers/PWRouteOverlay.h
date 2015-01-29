//
//  PWRouteOverlay.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

@class PWBuildingOverlay;
@class PWRoute;
@class PWRouteStep;

/**
 The `PWRouteOverlay` class defines a specific type of overlay that represents a route on a map.
 */
@interface PWRouteOverlay : NSObject <MKOverlay>

/**
 The route object associated with the overlay. (read-only)
 */
@property (readonly) PWRoute *route;

/**
 The current route step displayed on the overlay.  When changing this value, the step must belong to the current route and cannot be `nil`.  Setting the step will change the building overlay's floor as necessary.
 */
@property (nonatomic) PWRouteStep *currentStep;

/**
 Initializes the overlay with the specified route and building overlay. 
 @param route The route to display on the map.
 @param buildingOverlay The building overlay associated with the current route overlay.
 @discussion The route overlay is linked directly to the building overlay it's associated with. This allows the route overlay to switch the building floor when the route step changes.
 */
- (instancetype)initWithRoute:(PWRoute *)route buildingOverlay:(PWBuildingOverlay *)buildingOverlay;

@end
