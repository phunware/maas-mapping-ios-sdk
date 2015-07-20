//
//  PWMapView.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>
//#import <PWLocation/PWLocation.h>

#import "PWMapViewDelegateProtocol.h"
#import "PWMappingTypes.h"
#import "PWRouteSnappingTolerance.h"
#import "PWIndoorUserLocation.h"

@class PWBuildingOverlay;
@class PWBuilding;
@class PWBuildingFloor;
@class PWRoute;
@class PWRouteStep;
@class PWRouteManeuver;
@class PWLocation;
@class PWBuildingAnnotation;

/**
 A `PWMapView` object provides an embeddable map interface. It is similar to the one provided by the maps application but is specifically tailored to indoor maps. `PWMapView` subclasses `MKMapView` to provide a convenient interface that downloads, stores and displays indoor maps and associated points of interest (POIs). Usage of this class is optional but recommended for basic indoor map implementations. For more control, please refer to `PWBuildingManager`, `PWBuildingOverlay` and `PWRouteOverlay`,  which `PWMapView` is built upon.
 */

@interface PWMapView : MKMapView <UIGestureRecognizerDelegate>

/**
 The delegate for the map. The `PWMapViewDelegateProtocol` inherits from `MKMapViewDelegate`.
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
 Returns the currently displayed `PWBuildingFloor` object. This property may be `nil` if no floor is displayed. Attempts to change to the same floor are ignored. When the floor change is complete, the delegate will receive a `mapView:didChangeFloor:` callback.
 */
@property (nonatomic) PWBuildingFloor *currentFloor;

/**
 The current `PWRoute` object plotted on the map. This property will be `nil` if no route is displayed.
 */
@property (nonatomic, readonly) PWRoute *currentRoute;

/**
 This property determines whether the `PWBuildingAnnotation` objects for the current building will be passed through to the `mapView:viewForAnnotation` delegate method. If 'NO', building annotations will be assigned an appropriate `PWBuildingAnnotationView` internally.
 @discussion The default value is `NO`. If you set this property to `YES`, you will have to control the building annotation visibility.
 */
@property (nonatomic, readwrite) BOOL shouldReturnBuildingAnnotations;

/**
 All point of interest (POI) annotations for the current building, including POIs for all floors and zoom levels.
 @discussion This array is immutable and changes only when the current building is changed. This value is never `nil`.
 */
@property (readonly) NSArray *buildingAnnotations;

/**
 Hides a single point of interest from the map.
 @param identifier Annotation identifier for the building annotation to hide from the map.
 @discussion This does not remove the annotation from the map's `buildingAnnotations` array.
 */
- (void)hideBuildingAnnotationWithIdentifier:(PWAnnotationIdentifier)identifier;

/**
 Hides multiple points of interest from the map.
 @param identifiers Array of annotation identifiers (as NSNumber instances) for the building annotations to hide from the map.
 @discussion This does not remove the annotations from the map's `buildingAnnotations` array.
 */
- (void)hideBuildingAnnotationsWithIdentifiers:(NSArray*)identifiers;

/**
 Stops hiding a single point of interest from the map.
 @param identifier Annotation identifier for the building annotation to stop hiding from the map.
 */
- (void)stopHidingBuildingAnnotationWithIdentifier:(PWAnnotationIdentifier)identifier;

/**
 Stops hiding multiple points of interest from the map.
 @param identifiers Array of annotation identifiers (as NSNumber instances) for the building annotations to stop hiding from the map.
 */
- (void)stopHidingBuildingAnnotationsWithIdentifiers:(NSArray*)identifiers;

/**
 Focuses the map view to the provided annotation with optional animation.
 @param annotation An existing annotation found in the map's `buildingAnnotations` property. Attempting to use another annotation will be ignored.
 @param animated A Boolean flag to indicate whether the change in the view should be animated.
 @discussion This method will not work for object copies of POIs obtained from the building manager or elsewhere. In order to find an annotation by its identifier, name or other property, search the `buildingAnnotations` property. This method will automatically change floors on the map if necessary. It will also zoom in to the maximum zoom level.
 */
- (void)showBuildingAnnotation:(PWBuildingAnnotation*)annotation animated:(BOOL)animated;

///-------------------------------------
/// @name Initializing a Map View Object
///-------------------------------------

/**
 Initializes and returns a newly allocated map view object with the specified frame rectangle and building identifier.
 @discussion Proper use of this initialization method will kick off by fetching building data, points of interest and assets. This data will then be cached and displayed in the `PWMapView`. Upon successful completion, the delegate will receive a `mapView:didFinishLoadingBuilding:` callback. If the building identifier is invalid or if something went wrong, the delegate will receive a `mapView:didFailToLoadBuilding:error:` callback.
 @param frame The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
 @param buildingID The identifier for the building to load into the `PWMapView`.
 @return A new `PWMapView` object.
 */
- (instancetype)initWithFrame:(CGRect)frame buildingID:(NSInteger)buildingID;

/**
 Allows you to change the building displayed in the map view to the specified building identifier.
  @discussion Proper use of this method will kick off by fetching the building data, points of interest and assets. This data will then be cached and displayed in the `PWMapView`. Upon successful completion, the delegate will receive a `mapView:didFinishLoadingBuilding:` callback. If the building identifier is invalid or if something went wrong, the delegate will receive a `mapView:didFailToLoadBuilding:error:` callback.
 @param buildingID The identifier of the building to load into the `PWMapView`.
 */
- (void)loadBuildingWithIdentifier:(PWBuildingIdentifier)buildingID;

/**
 Stops all load building operations. If a building is currently loading the delegate callback, `mapView:didFailToLoadBuilding:error:` will be triggered with an appropriate error message.
 @discuss If no building is currently being loaded, this method has no effect.
 */
- (void)stopLoadingBuilding;


///-------------------------------------------
/// @name Displaying the Users Indoor Location
///-------------------------------------------

/**
 A Boolean value indicating whether the map should try to display the user’s indoor location. In order to display the user's indoor location, a `PWLocationManager` object must be registered with the map view. This method will have no affect if `registerLocationManagerForIndoorLocationUpdates:` is not called first.

 @discussion This property only indicates whether the map view should try to display the user's indoor position, not whether the user’s indoor position is actually visible on the map. Setting this property to 'YES' causes the map view to use the specified `PWLocationManager` object to find the current indoor location and to try displaying it on the map. As long as this property is 'YES', the map view will continue to track the user’s indoor location and update it periodically. The default value of this property is 'NO'.

 Showing the user’s indoor location does not guarantee that the location is visible on the map. The user might have scrolled the map to a different point, causing the current location to be offscreen. To determine whether the user’s location is currently displayed on the map, use the `userIndoorLocationVisible` property.
 
 When setting this property to `NO` follow `PWIndoorUserTrackingMode` will be set to `PWIndoorUserTrackingModeNone`.
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
 @discussion If blue dot smoothing is active, this property will report a calculated position and will thus be very volatile.
 */
@property (nonatomic, readonly) PWIndoorUserLocation *indoorUserLocation;

/**
 The mode used to track the user's indoor location.
 @discussion Possible values are described in `PWIndoorUserTrackingMode`. It's important to note that this property replaces the `userTrackingMode` property of type `MKUserTrackingMode` on `MKMapView`. Setting this value will have no effect if an indoor location manager has not been registered with the map view.

 Setting the tracking mode to `PWIndoorUserTrackingModeFollow` or `PWIndoorUserTrackingModeFollowWithHeading` causes the map view to center the map on that location and (optionally) orient the map with fixed north. If the map is zoomed out, the map view automatically zooms in on the user’s location, effectively changing the current visible region.
 */
@property (nonatomic) PWIndoorUserTrackingMode indoorUserTrackingMode;

/**
 Sets the mode used to track the user's indoor location with optional animation. This method will have no effect if an indoor location manager has not been registered with the map view.
 @param mode The mode used to track the user's location. Possible values are described in `PWIndoorUserTrackingMode`.
 @param animated If `YES`, the new mode is animated; otherwise, it is not. This parameter affects only tracking mode changes. Changes to the user's indoor location or heading are always animated.
 @discussion Setting the tracking mode to `PWIndoorUserTrackingModeFollow` or `PWIndoorUserTrackingModeFollowWithHeading` causes the map view to center the map on that location. If the map is zoomed out, the map view automatically zooms in on the user’s indoor location, effectively changing the current visible region.
 */
- (void)setIndoorUserTrackingMode:(PWIndoorUserTrackingMode)mode animated:(BOOL)animated;

/**
 Determines whether or not blue dot smoothing is used to provide a better visual experience when displaying the user's location.
 @discussion When based on information supplied by location providers, normal blue dot behavior is "jumpy" because location updates are received several times per second (at most). This feature "conditions" the user's reported location by first using a rolling average of the reported locations, then interpolating between average locations. This feature is turned on by default.
 */
@property BOOL blueDotSmoothingEnabled;

/**
 A Boolean value indicating whether the POI's zoom level is respecting Phunware's zoom level.
 @discussion When turned on, POIs respect the Phunware zoom level; when turned off, all POIs display (regardless of Phunware zoom level). This feature is turned on by default.
 */
@property BOOL annotationZoomLevelsEnabled;

/**
 Determines the route snapping behavior of the user's displayed location.
 @discussion This value is only used while in routing mode and is used to configure the route snapping feature. The possible values of this property are as follows:

  - PWRouteSnappingOff: no route snapping will be performed at all
  - PWRouteSnappingToleranceNormal: the user's location will be "snapped" to the nearest point on the route if the route is within the horizontal accuracy of the location being used (this is the default value)
  - PWRouteSnappingToleranceMedium: the user's location will be "snapped" to the nearest point on the route if the route is within 1.5 times the horizontal accuracy of the location being used
  - PWRouteSnappingToleranceHigh: the user's location will be "snapped" to the nearest point on the route if the route is within twice (2.0 times) the horizontal accuracy of the location being used
 */
@property PWRouteSnappingTolerance routeSnappingTolerance;


/**
 Register an indoor location manager provider with the map view. This location provider is used when modifying the `indoorUserTrackingMode` or when `showsIndoorUserLocation` is set to `YES`.
 @param locationManager The location manager to register with the map view. The location manager must conform to the `PWLocationManager` protocol.
 @discussion This method is deprecated. Please use `registerIndoorLocationManager:` instead.
 */
- (void)registerLocationManagerForIndoorLocationUpdates:(id<PWLocationManager>)locationManager __deprecated;


/**
 Register an indoor location manager provider with the map view. This location provider is used when modifying the `indoorUserTrackingMode` or when `showsIndoorUserLocation` is set to `YES`.
 @param locationManager The location manager to register with the map view. The location manager must conform to the `PWLocationManager` protocol.
 */
- (void)registerIndoorLocationManager:(id<PWLocationManager>)locationManager;

/**
 Unregister any indoor location manager provider that is registered with the map view.
 @discussion If the user's location is being displayed, it will not be hidden.
 */
- (void)unregisterIndoorLocationManager;


/**
 Notify a PWMapView instance that it is appearing onscreen in a view controller.
 @discussion This method must be called by all view controllers that display a PWMapView instance. It allows the map view to initiate processes related to location tracking and may be used for future enhancements. The call must be made during the view controller's `-viewWillAppear:` implementation.
 */
- (void)willAppear;

/**
 Notifies a PWMapView instance that it no longer appears onscreen in a view controller.
 @discussion This method must be called by all view controllers that display a PWMapView instance. It allows the map view to throttle down processes related to location tracking and may be used for future enhancements. The call must be made during the view controller's `-viewDidDisappear:` implementation.
 */
- (void)didDisappear;


///-------------------------
/// @name Displaying a Route
///-------------------------

/**
 Load a `PWRoute` object into the map view. This method will plot a basic route line on the map view. The route object must not be `nil`.
 @param route The `PWRoute` object to display in the map view. By default, the first `PWRouteStep` is plotted.
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
 Display the specified `PWRouteManeuver` on the map. If needed, this will change the current floor to the required floor for the maneuver.
 @param maneuver The `PWRouteManeuver` to display.
 @discussion This method will not reposition the map to display the maneuver
 */
- (void)setRouteManeuver:(PWRouteManeuver *)maneuver;

/**
 Display the specified `PWRouteManeuver` on the map and animates to its position. If needed, this will change the current floor to the required floor for the maneuver.
 @param maneuver The `PWRouteManeuver` to display.
 */
- (void)setRouteManeuver:(PWRouteManeuver *)maneuver animated:(BOOL)animated;

/**
 Returns the current `PWRouteManeuver` being displayed. If no route is displayed, this method will return `nil`.
 @return The current `PWRouteManeuver`. Can be `nil` if no `PWRoute` is loaded or if turn-by-turn routing is not being used.
 */
- (PWRouteManeuver*)currentManeuver;

/**
 Cancel the route displayed in the map view. This method will remove the route from the map view and set the `PWRoute` and `PWRouteStep` properties to `nil`.
 */
- (void)cancelRouting;

@end
