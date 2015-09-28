//
//  PWMapViewDelegateProtocol.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWIndoorUserTracking.h"

@protocol PWLocationManager;
@class PWMapView;
@class PWBuilding;
@class PWBuildingFloor;
@class PWIndoorLocation;
@class PWBuildingFloor;
@class PWBuilding;
@class PWRouteStep;
@class PWRouteManeuver;


/**
 The `PWMapViewDelegate` protocol defines a set of optional methods that you can use to receive building-related update messages. Since many map operations require the `PWMapView` class to load data asynchronously, the map view calls these methods to notify your application when specific operations complete. `PWMapViewDelegate` inherits from `MKMapViewDelegate`.
 */
@protocol PWMapViewDelegateProtocol <MKMapViewDelegate>

@optional

///---------------------------
/// @name Loading the Map Data
///---------------------------

/**
 Tells the delegate that the specified map view successfully changed the building floor.
 @param mapView The map view that changed the floor.
 @param currentFloor The current floor displayed in the map view.
 @discussion This method is called when the floor data has finished loading and is ready to be displayed on the map.
 */
- (void)mapView:(PWMapView *)mapView didChangeFloor:(PWBuildingFloor *)currentFloor;

/**
 Tells the delegate that the specified map view successfully loaded necessary building data.
 @param mapView The map view that started the load operation.
 @param building The building that was loaded.
 @discussion This method is called when the building data has finished loading and is ready to be displayed on the map.
 */
- (void)mapView:(PWMapView *)mapView didFinishLoadingBuilding:(PWBuilding *)building;

/**
 Tells the delegate that the specified view was unable to load the building data.
 @param mapView The map view that started the load operation.
 @param buildingID The identifier for the building that the map view tried to load data for.
 @param error The reason that the map data could not be loaded.
 @discussion This method might be called in situations where the device does not have access to the network or is unable to load the building data. On a successful load, building data and assets are cached for future use.
 */
- (void)mapView:(PWMapView *)mapView didFailToLoadBuilding:(NSInteger)buildingID error:(NSError *)error;


///---------------------------------
/// @name Tracking the User's Location
///---------------------------------

/**
 Tells the delegate that the map view will start tracking the user’s indoor location.
 @param mapView The map view tracking the user’s location.
 @discussion This method is called when the value of the `showsIndoorUserLocation` property changes to `YES`.
 */
- (void)mapViewWillStartLocatingIndoorUser:(PWMapView *)mapView;

/**
 Tells the delegate that the map view stopped tracking the user’s indoor location.
 @param mapView The map view that stopped tracking the user’s indoor location.
 @discussion This method is called when the value of the `showsIndoorUserLocation` property changes to `NO`.
 */
- (void)mapViewDidStopLocatingIndoorUser:(PWMapView *)mapView;

/**
 Tells the delegate that the indoor location of the user was updated.
 @param mapView The map view tracking the user’s location.
 @param userLocation The location object representing the user’s latest location. This property may be `nil`.
 @discussion While the showsIndoorUserLocation property is set to `YES`, this method is called whenever a new location update is received by the map view.
 */
- (void)mapView:(PWMapView *)mapView didUpdateIndoorUserLocation:(PWIndoorLocation *)userLocation __deprecated;

- (void)mapView:(PWMapView *)mapView locationManager:(id<PWLocationManager>)locationManager didUpdateIndoorUserLocation:(PWIndoorLocation *)userLocation;

/**
 Tells the delegate that an attempt to locate the user’s position failed.
 @param mapView The map view tracking the user’s indoor location.
 @param error An error object containing the reason why location tracking failed.
 */

- (void)mapView:(PWMapView *)mapView didFailToLocateIndoorUserWithError:(NSError *)error;

/**
 Tells the delegate that the user's location was updated.
 @param mapView The map view with the altered user tracking mode.
 @param mode The mode used to track the user’s location.
 */
- (void)mapView:(PWMapView *)mapView didChangeIndoorUserTrackingMode:(PWIndoorUserTrackingMode)mode;


///--------------
/// @name Routing
///--------------

/**
 Tells the delegate that the user's location has been snapped to a route.
 @param mapView The map view snapping locations to a route.
 @discussion This method notifies the map view delegate that the map view has begun snapping user locations to a route.
 */
- (void)mapViewStartedSnappingLocationToRoute:(PWMapView *)mapView;

/**
 Tells the delegate that the user's location was not snapped to a route.
 @param mapView The map view no longer snapping locations to a route.
 @discussion This method notifies the map view delegate that the map view has ceased snapping user locations to a route.
 */
- (void)mapViewStoppedSnappingLocationToRoute:(PWMapView *)mapView;

/**
 Tells the delegate that the route step being displayed has changed.
 @param mapView The map view reporting the step change.
 @param step The new route step being displayed on the map.
 */
- (void)mapView:(PWMapView*)mapView didChangeRouteStep:(PWRouteStep*)step;

/**
 Tells the delegate that the route step being displayed has changed.
 @param mapView The map view reporting the step change.
 @param maneuver The new route maneuver being displayed on the map, or nil if it has been cleared.
 */
- (void)mapView:(PWMapView*)mapView didChangeRouteManeuver:(PWRouteManeuver*)maneuver;

/**
 Asks the delegate whether the automatic maneuver change should be animated.
 @param mapView The map view asking whether or not to animate automatic maneuver changes.
 @return A Boolean value indicating whether or not to animate automatic maneuver changes.
 @discussion The automatic maneuver changes will be animated by default.
 */
- (BOOL)mapViewShouldAnimateAutomaticRouteManeuverChange:(PWMapView *)mapView;

///-----------------------
/// @name Tracking Heading
///-----------------------

/**
 Asks the delegate whether the heading calibration display should be shown.
 @param mapView The map view asking whether or not to display the heading calibration.
 @return A Boolean value indicating whether or not the heading calibration should be displayed.
 @discussion The heading calibration will not be displayed by default.
 */
- (BOOL)mapViewShouldDisplayHeadingCalibration:(PWMapView *)mapView;

/**
 Tells the delegate that the user's heading has changed.
 @param mapView The map view reporting the change in user heading.
 @param heading The new heading value being reported.
 */
- (void)mapView:(PWMapView *)mapView didUpdateHeading:(CLHeading*)heading;


@end
