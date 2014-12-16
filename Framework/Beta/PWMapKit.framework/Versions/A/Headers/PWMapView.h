//
//  PWMapView.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <PWLocation/PWLocation.h>

#import "PWMapViewDelegateProtocol.h"
#import "PWMappingTypes.h"

@class PWBuildingOverlay;
@class PWBuilding;
@class PWBuildingFloor;
@class PWRoute;
@class PWRouteStep;
@class PWLocation;
@class PWBuildingAnnotation;

/**
 A `PWMapView` object provides an embeddable map interface. It is similar to the one provided by the maps application but is specifically tailored for indoor maps. `PWMapView` subclasses `MKMapView` to provide a convenient interface that downloads, stores and displays indoor maps and associated points of interest. Usage of this class is optional but recommended for basic indoor map implementations. For more control, please refer to `PWBuildingManager`, `PWBuildingOverlay` and `PWRouteOverlay`,  which `PWMapView` is built upon.
 */

@interface PWMapView : MKMapView <UIGestureRecognizerDelegate>

/**
 The delegate for the map.  The `PWMapViewDelegateProtocol` inherits from `MKMapViewDelegate`.
 */
@property (nonatomic, weak) id <PWMapViewDelegateProtocol> delegate;

///-------------------------------
/// @name Accessing Map Properties
///-------------------------------

/**
 The identifier of the building associated with the current map. If no building is associated with the `PWMapView`, the building ID value will be `NSNotFound`.
*/
@property (nonatomic, readonly) PWBuildingIdentifier buildingID;

/**
 The `PWBuilding` object associated with the current map. If no building is associated with the `PWMapView`, the building will be `nil`.
 */
@property (nonatomic, readonly) PWBuilding *building;

/**
 Returns the current `PWBuildingFloor` object. This property may be `nil` if no floor is displayed.
 */
@property (nonatomic, readonly) PWBuildingFloor *currentFloor;

/**
 The current `PWRoute` object plotted on the map. This property will be `nil` if no route is displayed.
 */
@property (nonatomic, readonly) PWRoute *currentRoute;

/**
 This property controls whether the `PWBuildingAnnotation` objects for the current building will be passed through to the `mapView:viewForAnnotation` delegate method. Otherwise, building annotations will be assigned an appropriate `PWBuildingAnnotationView` internally.
 @discussion The default value is `NO`. If you set this property to `YES`, you will have to control the building annotation visbility state.
 */
@property (nonatomic, readwrite) BOOL shouldReturnBuildingAnnotations;

/**
 All POI annotations for the current building.  Includes POIs for all floors and zoom levels.
 @discussion This array is immutable and changes only when the current building is changed.  This value is never `nil`.
 */
@property (readonly) NSArray *buildingAnnotations;

/**
 Focuses the map view to the provided annotation with optional animation.
 @param annotation An existing annotation found in the map's `buildingAnnotations` property.  Attempting to use another annotation will be ignored.
 @param animated Boolean flag to indicate whether or not the change in the view should be animated.
 @discussion This method will not work for object copies of POIs obtained from the building manager or elsewhere.  In order to find an annotation by identifier, name, or other property, simply search the `buildingAnnotations` property.  This method will automatically change floors on the map if necessary.  It will also zoom in to the maximum zoom level.
 */
- (void)showBuildingAnnotation:(PWBuildingAnnotation*)annotation animated:(BOOL)animated;

///-------------------------------------
/// @name Initializing a Map View Object
///-------------------------------------

/**
 Initializes and returns a newly allocated map view object with the specified frame rectangle and building identifier.
 @discussion Proper use of this initialization method will kick off by fetching building data, points of interest and assets. This data will then be cached and displayed in the `PWMapView`. Upon successful completion, the delegate will receive a `mapView:didFinishLoadingBuilding:` callback. If the building identifier is invalid or something went wrong, the delegate will receive a `mapView:didFailToLoadBuilding:error:` callback.
 @param frame The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
 @param buildingID The identifier for the building to load into the `PWMapView`.
 @return A new `PWMapView` object.
 */
- (instancetype)initWithFrame:(CGRect)frame buildingID:(NSInteger)buildingID;

/**
 Allows you change the building displayed in the map view to the specified building identifier.
  @discussion Proper use of this method will kick off by fetching the building data, points of interest and assets. This data will then be cached and displayed in the `PWMapView`. Upon successful completion, the delegate will receive a `mapView:didFinishLoadingBuilding:` callback. If the building identifier is invalid or something went wrong, the delegate will receive a `mapView:didFailToLoadBuilding:error:` callback.
 @param buildingID The identifier for the building you would like to load into the `PWMapView`.
 */
- (void)loadBuildingWithIdentifier:(PWBuildingIdentifier)buildingID;

/**
 Change the currently displayed floor to another `PWBuildingFloor` object. Passing the same floor will have no effect. When the floor change is complete, the delegate will receive a `mapView:didChangeFloor:` callback.
 @param floor The `PWBuildingFloor` object you would like to set as the current floor.
 */
- (void)setCurrentFloor:(PWBuildingFloor *)floor;

///-------------------------------------------
/// @name Displaying the Users Indoor Location
///-------------------------------------------

/**
 A Boolean value indicating whether the map should try to display the user’s indoor location. In order to display the user's indoor location you must have registered a `PWLocationManager` object with the map view. This method will have no affect if `registerLocationManagerForIndoorLocationUpdates:` is not called first.
 
 @discussion This property only indicates whether the map view should try to display the user's indoor position, not whether the user’s indoor position is actually visible on the map. Setting this property to YES causes the map view to use the specified `PWLocationManager` object to find the current indoor location and to try displaying it on the map. As long as this property is YES, the map view continues to track the user’s indoor location and update it periodically. The default value of this property is NO.
 
 Showing the user’s indoor location does not guarantee that the location is visible on the map. The user might have scrolled the map to a different point, causing the current location to be offscreen. To determine whether the user’s current location is currently displayed on the map, use the `userIndoorLocationVisible` property.
 */

@property (nonatomic) BOOL showsIndoorUserLocation;

/**
 A Boolean value indicating whether the device’s current indoor location is visible in the map view. (read-only)
 
 @discussion This property tells you whether the icon used to represent the user’s current indoor location is visible in the map view. When determining whether the current indoor location is visible, this property factors in the horizontal accuracy of the location data. 
 
 Specifically, if the rectangle represented by the user’s current location plus or minus minus the horizontal accuracy of that location intersects the map’s visible rectangle, this property contains the value `YES`. 
 
 If that location rectangle does not intersect the map’s visible rectangle, this property contains the value `NO`.
 
 If the user’s indoor location cannot be determined, this property contains the value `NO`.
 */
@property (nonatomic, readonly, getter = isIndoorUserLocationVisible) BOOL indoorUserLocationVisible;

/**
 The object representing the user’s current indoor location. (read-only)
 */
@property (nonatomic, readonly) PWIndoorLocation *indoorUserLocation;

/**
 The mode used to track the user's indoor location.
 @discussion Possible values are described in `PWIndoorUserTrackingMode`. It's important to note that `MKUserTrackingMode` and `PWIndoorUserTrackingMode` are mutually exclusive. Setting this value will have no affect if `registerLocationManagerForIndoorLocationUpdates:` is not called first.
 
 Setting the tracking mode to PWIndoorUserTrackingModeFollow or PWIndoorUserTrackingModeFollowWithHeading causes the map view to center the map on that location and begin tracking the user’s location. If the map is zoomed out, the map view automatically zooms in on the user’s location, effectively changing the current visible region.
 */
@property (nonatomic) PWIndoorUserTrackingMode indoorUserTrackingMode;

/**
 Sets the mode used to track the user's indoor location with optional animation. This method will have no affect if `registerLocationManagerForIndoorLocationUpdates:` is not called first.
 @param mode The mode used to track the user's location. Possible values are described in `PWIndoorUserTrackingMode`.
 @param animated If `YES`, the new mode is animated; otherwise, it is not. This parameter affects only tracking mode changes. Changes to the user's indoor location or heading are always animated.
 @discussion Setting the tracking mode to `PWIndoorUserTrackingModeFollow` or `PWIndoorUserTrackingModeFollowWithHeading` causes the map view to center the map on that location and begin tracking the user’s indoor location. If the map is zoomed out, the map view automatically zooms in on the user’s indoor location, effectively changing the current visible region.
 */
- (void)setIndoorUserTrackingMode:(PWIndoorUserTrackingMode)mode animated:(BOOL)animated;

/**
 Register an indoor location manager provider with the map view. This location provider is used when modifying the `indoorUserTrackingMode` or when `showsIndoorUserLocation` is set to `YES`.
 @param locationManager The location manager to register with the map view. The location manager must conform to the `PWLocationManager` protocol.
 */
- (void)registerLocationManagerForIndoorLocationUpdates:(id<PWLocationManager>)locationManager;

/**
 Notify a PWMapView instance that it is appearing on screen in a view controller.
 @discussion This method should be called by all view controllers that display a PWMapView instance.  It allows the map view to initiate processes related to location tracking and may be used for future enhancements.  The call should be made during the view controller's `-viewWillAppear:` implementation.
 */
- (void)willAppear;

/**
 Notify a PWMapView instance that it no longer appears on screen in a view controller.
 @discussion This method should be called by all view controllers that display a PWMapView instance.  It allows the map view to throttle down processes related to location tracking and may be used for future enhancements.  The call should be made during the view controller's `-viewDidDisappear:` implementation.
 */
- (void)didDisappear;


///-------------------------
/// @name Displaying a Route
///-------------------------

/**
 Load a `PWRoute` object into the the map view. This method will plot a basic route line on the map view. The route object must not be `nil`.
 @param route The `PWRoute` object you wish to display on the map view. By default, the first `PWRouteStep` is plotted.
 */
- (void)plotRoute:(PWRoute *)route;

/**
 Display the specified `PWRouteStep` on the map. This will change the current floor to the required floor for the `PWRouteStep`.
 @param step The `PWRouteStep` to display.
 */
- (void)setRouteStep:(PWRouteStep *)step;

/**
 Returns the current `PWRouteStep`. If no route is displayed, this method will return `nil`.
 @return The current `PWRouteStep`. Can be `nil` if no `PWRoute` is loaded.
 */
- (PWRouteStep *)currentStep;

/**
 Cancel the route being displayed in the map view. This method will remove the route from the map view and set the `PWRoute` and `PWRouteStep` properties to `nil`.
 */
- (void)cancelRouting;

@end

