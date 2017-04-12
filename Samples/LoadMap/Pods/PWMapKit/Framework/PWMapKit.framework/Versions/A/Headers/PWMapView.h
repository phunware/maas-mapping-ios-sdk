//
//  PWMapView.h
//  PWMapKit
//
//  Created by Steven Spry on 5/12/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "PWBuilding.h"
#import "PWFloor.h"
#import "PWPointOfInterest.h"
#import "PWRouteInstruction.h"
#import "PWCustomLocation.h"
#import "PWBuildingAnnotationView.h"

@protocol PWLocationManager;
@class PWIndoorLocation;

/**
 *  Supported location providers types.
 */
typedef NS_ENUM(NSInteger, PWMapViewLocationType) {
    /**
     *  Location provider type none.
     */
    PWMapViewLocationTypeNone,
    /**
     *  Location provider type MSE.
     */
    PWMapViewLocationTypeMSE,
    /**
     *  Location provider type BLE.
     */
    PWMapViewLocationTypeBLE,
    /**
     *  Location provider type GPS.
     */
    PWMapViewLocationTypeGPS,
    /**
     *  Location provider type Fused.
     */
    PWMapViewLocationTypeFused,
    /**
     *  Location provider type Mock.
     */
    PWMapViewLocationTypeMock
};

/**
 * Supported Route Snapping Tolerance values.
 */
typedef NS_ENUM(NSUInteger, PWRouteSnapTolerance) {
    /**
     *  Route Snapping off.
     */
    PWRouteSnapOff,
    /**
     *  Route Snapping normal.
     */
    PWRouteSnapToleranceNormal,
    /**
     *  Route Snapping medium.
     */
    PWRouteSnapToleranceMedium,
    /**
     *  Route Snapping high.
     */
    PWRouteSnapToleranceHigh
};

/**
 * Supported Tracking mode values.
 */
typedef NS_ENUM(NSUInteger, PWTrackingMode) {
    /**
     *  Tracking mode off.
     */
    PWTrackingModeNone,
    /**
     *  Tracks user movement of the map.
     */
    PWTrackingModeFollow,
    /**
     *  Tracks user movement of the map and rotates when the heading changes.
     */
    PWTrackingModeFollowWithHeading
};

/**
 *  Location provider configuration key for floor mapping
 */
extern NSString *const PWMapViewLocationTypeFloorMapping;

/**
 *  Location provider configuration key for MSE venue GUID
 */
extern NSString *const PWMapViewLocationTypeMSEVenueGUIDKey;

/**
 *  Location provider configuration key for SenionLab map identifier
 */
extern NSString *const PWMapViewLocationTypeBLEMapIdentifierKey;

/**
 *  Location provider configuration key for SenionLab customer identifier
 */
extern NSString *const PWMapViewLocationTypeBLECustomIdentifierKey;

/**
 * Notification key used when the user changes a route instruction.
 */
extern NSString *const PWRouteInstructionChangedNotificationKey;

@class PWMapView;

/**
 *  PWMapViewDelegate protocol definition
 */
@protocol PWMapViewDelegate <NSObject>

@optional
/**
 *  Tells the delegate that the region displayed by the map view is about to change.
 *
 *  @param mapView          The current map view instance.
 *  @param animated         If YES, the change to the new region will be animated. If NO, the change will be made immediately.
 */
- (void)mapView:(PWMapView *)mapView regionWillChangeAnimated:(BOOL)animated;

/**
 *  Tells the delegate that the region displayed by the map view just changed.
 *
 *  @param mapView          The current map view instance.
 *  @param animated         If YES, the change to the new region will be animated. If NO, the change will be made immediately.
 */
- (void)mapView:(PWMapView *)mapView regionDidChangeAnimated:(BOOL)animated;

/**
 *  Tells the delegate that the specified map view is about to retrieve some map data.
 *
 *  @param mapView          The current map view instance.
 */
- (void)mapViewWillStartLoadingMap:(PWMapView *)mapView;

/**
 *  Tells the delegate that the specified map view successfully loaded the needed map data.
 *
 *  @param mapView          The current map view instance.
 */
- (void)mapViewDidFinishLoadingMap:(PWMapView *)mapView;

/**
 *  Tells the delegate that the specified view was unable to load the map data.
 *
 *  @param mapView          The map view that started the load operation.
 *  @param error            The reason that the map data could not be loaded.
 */
- (void)mapViewDidFailLoadingMap:(PWMapView *)mapView withError:(NSError *)error;

/**
 *  Tells the delegate that the map view is about to start rendering some of its tiles.
 *
 *  @param mapView          The current map view instance.
 */
- (void)mapViewWillStartRenderingMap:(PWMapView *)mapView;

/**
 *  This delegate is called when the map view has finished rendering the map.
 *
 *  @param mapView          The current map view instance.
 *  @param fullyRendered BOOL value to tell if the map view has been fully rendered.
 */
- (void)mapViewDidFinishRenderingMap:(PWMapView *)mapView fullyRendered:(BOOL)fullyRendered;

/**
 Tells the delegate that the `PWBuildingAnnotationView` was selected by the user.
 @param mapView             The current map view instance.
 @param view                The selected `PWBuildingAnnotationView` object.
 @param poi                 The PointOfInterest.
 */
- (void)mapView:(PWMapView *)mapView didSelectBuildingAnnotationView:(PWBuildingAnnotationView *)view withPointOfInterest:(PWPointOfInterest *)poi;

/**
 Tells the delegate that the `PWBuildingAnnotationView` was deselected by the user.
 @param mapView             The current map view instance.
 @param view                The selected `PWBuildingAnnotationView` object.
 @param poi                 The PointOfInterest.
 */
- (void)mapView:(PWMapView *)mapView didDeselectBuildingAnnotationView:(PWBuildingAnnotationView *)view withPointOfInterest:(PWPointOfInterest *)poi;

/**
 Tells the delegate that one or more building annotation views were added to the map.
 @param mapView             The current map view instance.
 @param views                The selected `PWBuildingAnnotationView` object.
 */
- (void)mapView:(PWMapView *)mapView didAddBuildingAnnotationViews:(NSArray<PWBuildingAnnotationView *> *)views;

/**
 Tells the delegate that the building was added to the map.
 @param mapView             The current map view instance.
 @param building            The building object.
 */
- (void)mapView:(PWMapView *)mapView didFinishLoadingBuilding:(PWBuilding *)building;

/**
 Tells the delegate that the building failed to load into the map.
 @param mapView             The current map view instance.
 @param building            The building object.
 @param error               The reason that the building data could not be loaded.
 */
- (void)mapView:(PWMapView *)mapView didFailToLoadBuilding:(PWBuilding *)building error:(NSError *) error;

/**
 Tells the delegate that the map changed floors.
 @param mapView             The current map view instance.
 @param currentFloor        The floor object.
 */
- (void)mapView:(PWMapView *)mapView didChangeFloor:(PWFloor *)currentFloor;

/**
 *  This delegate is called prior to an annotation being displayed. The SDK user has the opportunity to modify the UI of the annotation; such as left/right/detail views and call-outs.
 *
 *  @param mapView The current map view instance.
 *  @param view    The annotation view tapped.
 *  @param poi     The point of iterest represented by the annotation.
 */
- (void)mapView:(PWMapView *)mapView didAnnotateView:(PWBuildingAnnotationView *)view withPointOfInterest:(PWPointOfInterest *)poi;

/**
 *  This delegate is called when a UIControl (UIButton, etc) is tapped on the custom annotation.
 *
 *  @param mapView The current map view instance.
 *  @param view    The annotation view tapped.
 *  @param control The callout accessory control tapped.
 *  @param poi     The point of iterest represented by the annotation.
 */
- (void)mapView:(PWMapView *)mapView annotationView:(PWBuildingAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control withPointOfInterest:(PWPointOfInterest *)poi;

/**
 *  This delegate is called when the the route instruction for the map has changed.
 *
 *  @param mapView          The current map view instance.
 *  @param routeInstruction The new route instruction.
 */
- (void)mapView:(PWMapView *)mapView didChangeRouteInstruction:(PWRouteInstruction *)routeInstruction;

/**
 *  This delegate is called when the heading of the user is updated. startUpdatingHeading must be called for this service to start.
 *
 *  @param mapView          The current map view instance.
 *  @param heading          The updated heading object.
 */
- (void)mapView:(PWMapView *)mapView didUpdateHeading:(CLHeading *)heading;

/**
 Tells the delegate that the indoor location of the user was updated.
 @param mapView             The map view tracking the user’s location.
 @param locationManager     The location manager providing location updates.
 @param userLocation        The location object representing the user’s latest location. This property may be `nil`.
 @discussion While the showsIndoorUserLocation property is set to `YES`, this method is called whenever a new location update is received by the map view.
 */
- (void)mapView:(PWMapView *)mapView locationManager:(id<PWLocationManager>)locationManager didUpdateIndoorUserLocation:(PWIndoorLocation *)userLocation;

/**
 *  This delegate is called when the user location is close enough to a route instruction that the SDK will snap the blue dot to the route.
 *  @param mapView          The current map view instance.
 */
- (void)mapViewStartedSnappingLocationToRoute:(PWMapView *)mapView;

/**
 *  This delegate is called when the user location is too far from any route instruction to snap the blue dot to a route instruction. Distance threshold is based on current routeSnappingTolerance.
 *  @param mapView          The current map view instance.
 */
- (void)mapViewStoppedSnappingLocationToRoute:(PWMapView *)mapView;

/**
 *  This delegate is called when the tracking mode of the map is changed.
 *  @param mapView           The current map view instance.
 *  @param mode              The new tracking mode.
 */
- (void)mapView:(PWMapView *)mapView didChangeTrackingMode:(PWTrackingMode)mode;

/**
 *  Returns the view associated with the specified annotation object.
 *
 *  @param mapView The map view that requested the annotation view.
 *  @param annotation The object representing the annotation that is about to be displayed.
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation;

/**
 *  Asks the delegate for a renderer object to use when drawing the specified overlay.
 *
 *  @param mapView The map view that requested the renderer object.
 *  @param overlay The overlay object that is about to be displayed.
 */
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay;

@end

/**
 *  The PWMapClass displays a building structure in an MKMapKit environment.
 */
@interface PWMapView : UIView

/**---------------------------------------------------------------------------------------
 * @name Properties
 * ---------------------------------------------------------------------------------------
 */

/**
 *  The receiver’s delegate.
 */
@property (nonatomic, weak) id<PWMapViewDelegate> delegate;

/**
 *  The location provider currently used by the map view.
 */
@property (nonatomic,readonly) PWMapViewLocationType mapViewLocationType;

/**
 *  The building currently loaded into the Map View.
 */
@property (nonatomic,readonly) PWBuilding *building;

/**
 *  The floor currently displayed within the building.
 */
@property (nonatomic) PWFloor *currentFloor;

/**
 *  A property to access the map view user tracking bar button.
 */
@property (nonatomic) UIBarButtonItem *userTrackingBarButtonItem;

/**
 *  A reference to the current custom location after the map view has been asked to navigate to a custom location (Current user position or a dropped pin).
 */
@property (nonatomic) PWCustomLocation *customLocation;

/**
 *  A reference to the user's current location.
 */
@property (strong,nonatomic, readonly) PWCustomLocation *userLocation;

/**
 *  The current type of location provider for the map view.
 */
@property (nonatomic) PWMapViewLocationType currentLocationProviderType;

/**
 *  The type of data displayed by the map view.
 */
@property(nonatomic) MKMapType mapType;

/**
 *  The latitude and longitude of the center of the map view's display.
 */
@property(nonatomic,readonly) CLLocationCoordinate2D centerCoordinate;

/**
 *  The route snapping tolerance value.
 */
@property (nonatomic) PWRouteSnapTolerance routeSnappingTolerance;

/**
 *  The map view's current route if any.
 */
@property(nonatomic) PWRoute *currentRoute;

/**
 *  The map view's current route instruction if any.
 */
@property(nonatomic) PWRouteInstruction *currentRouteInstruction;

/**
 *  The tracking mode of the map. Any mode besides PWTrackingModeNone automatically controls the map camera.
 */
@property(nonatomic) PWTrackingMode trackingMode;

/**
 *  The camera used for determining the appearance of the map.  A camera object defines a point above the map’s surface from which to view the map.
 */
@property(nonatomic, readonly) MKMapCamera *camera;

/**
 *  The area currently displayed by the map view.
 */
@property(nonatomic,readonly) MKCoordinateRegion region;

/**
 *  The area currently displayed by the map view.  This property represents the same basic information as the region property but specified as a map rectangle instead of a region.
 
    Changing the value of this property updates the map view immediately. If you want to animate the change, use the setVisibleMapRect:animated: method instead.
 */
@property(nonatomic) MKMapRect visibleMapRect;

/**
 *  The resolution of current map view.
 */
@property(nonatomic, readonly) NSInteger zoomLevel;

/**---------------------------------------------------------------------------------------
 * @name Instance Methods
 * ---------------------------------------------------------------------------------------
 */

/**
 *  Sets the location provider to be used by the map.
 *
 *  @param mapViewLocationType The location provider to use. See PWMapViewLocationType for a list of supported location providers.
 *  @param configuration       NSDictionary of configuration key/values. Each Location Type defines its own expected values.
 */
- (void)setMapViewLocationType:(PWMapViewLocationType)mapViewLocationType configuration:(NSDictionary *)configuration;

/**
 *  Sets the building object to be used by the map.
 *
 *  @param building The valid building object to display.
 */
- (void)setBuilding:(PWBuilding *)building;

/**
 *  Sets the current floor of the building that should be displayed on the map.
 *
 *  @param floor The floor object to display
 */
- (void)setFloor:(PWFloor *)floor;

/**
 *  Repositions the map's view to a custom location.
 *
 *  @param location A custom location reference where the map should navigate to.
 */
- (void)navigateToCustomLocation:(PWCustomLocation *)location;

/**
 *  Repositions the map's view to an specific point of interest.
 *
 *  @param poi A point of interest reference where the map should navigate to.
 */
- (void)navigateToPointOfInterest:(PWPointOfInterest *)poi;

/**
 *  Displays the array of Points of Interest, causing the map view to zoom in/out to contain all of the points of interest.
 *
 *  @param pois An array of PWPointOfInterest objects that should be displayed on the map.
 */
- (void)showPointsOfInterest:(NSArray *)pois;

/**
 *  Selects a PointOfInterest on the map.
 *
 *  @param poi              A PointOfInterest to select on the map.
 *  @param animated         A BOOL property to determine whether the change of map's region should be animated or not.
 */
- (void) selectPointOfInterest:(PWPointOfInterest *) poi animated:(BOOL) animated;

/**
 *  Deselects a PointOfInterest on the map.  If the POI is not selected, this method does nothing
 *
 *  @param poi              A PointOfInterest to deselect on the map.
 *  @param animated         A BOOL property to determine whether the change of map's region should be animated or not.
 */
- (void) deselectPointOfInterest:(PWPointOfInterest *)poi animated:(BOOL) animated;

/**
 *  Returns the annotation view of a PointOfInterest.
 *
 *  @param poi The Point of Interest. This parameter must not be nil.
 *  @discussion This method returns nil if the PointOfInterest if not visible in the Map.  This is due to reuse.
 */
- (PWBuildingAnnotationView *) viewForPointOfInterest:(PWPointOfInterest *) poi;

/**
 *  Repositions the map view to display the given route.
 *
 *  @param route The route object that will be used to navigate within the map.
 */
- (void)navigateWithRoute:(PWRoute *)route;

/**
 *  Sets and dislays the current navitation instruction/steps during a navigation.
 *
 *  @param instruction A route instruction object for the route.
 */
- (void)setRouteManeuver:(PWRouteInstruction *)instruction;

/**
 *  Stops the current routing task.
 */
- (void)cancelRouting;

/**
 *  Positions the map to the supplied center coordinate with the given zoom level and optional animation.
 *
 *  @param centerCoordinate A CLLocationCoordinate2D object representing the latitude an longitude the map should zoom to.
 *  @param zoomLevel        A NSUInteger value representing zoom level the map should zoom to.
 *  @param animated         A BOOL property to determine whether the change of map's center should be animated or not.
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;

/**
 *  Positions the map to the supplied center coordinate with the optional animation.
 *
 *  @param centerCoordinate A CLLocationCoordinate2D object representing the latitude an longitude the map should zoom to.
 *  @param animated         A BOOL property to determine whether the change of map's center should be animated or not.
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate animated:(BOOL)animated;

/**
 *  Positions the map to the supplied MKCoordinateRegion with optional animation.
 *
 *  @param region A MKCoordinateRegion object representing the coordinate and span the map should display.
 *  @param animated         A BOOL property to determine whether the change of map's region should be animated or not.
 */
- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated;

/**
 *  Changes the currently visible portion of the map and optionally animates the change.
 *
 *  @param visibleMapRect The map rectangle to make visible in the map view.
 *  @param animated         A BOOL property to determine whether the change of map's region should be animated or not.
 */
- (void)setVisibleMapRect:(MKMapRect)visibleMapRect animated:(BOOL)animated;

/**
 *  Starts heading updates that may be received from the PWMapViewDelegate.
 */
- (void)startUpdatingHeading;

/**
 *  Stops heading updates. Causes didUpdateHeading in PWMapViewDelegate to stop firing.
 */
- (void)stopUpdatingHeading;

/**
 *  Changes the camera used for determining the map’s viewing parameters and optionally animates the change.
 *
 *  @param camera The camera object containing the viewing angle information. This parameter must not be nil.
 *  @param animated         A BOOL property to determine whether the change of map's region should be animated or not.
 */
- (void) setCamera:(MKMapCamera *) camera animated:(BOOL)animated;

/**
 Register an location manager provider with the map view. This location provider is used when modifying the `indoorUserTrackingMode` or when `showsIndoorUserLocation` is set to `YES`.
 @param locationManager The location manager to register with the map view. The location manager must conform to the `PWLocationManager` protocol.
 */
- (void)registerLocationManager:(id<PWLocationManager>)locationManager;

/**
 Unregister any location manager provider that is registered with the map view.
 @discussion If the user's location is being displayed, it will not be hidden.
 */
- (void)unregisterLocationManager;

/**
 *  Adds the specified annotation to the PWMapView.
 *
 *  @param annotation The annotation object to add to the receiver. This object must conform to the MKAnnotation protocol.
 */
- (void)addAnnotation:(id<MKAnnotation>)annotation;

/**
 *  Adds an array of annotation objects to the PWMapView.
 *
 *  @param annotations An array of annotation objects. Each object in the array must conform to the MKAnnotation protocol.
 */
- (void)addAnnotations:(NSArray<id<MKAnnotation>> *)annotations;

/**
 *  Removes the specified annotation object from the PWMapView.
 *
 *  @param annotation The annotation object to remove. This object must conform to the MKAnnotation protocol.
 */
- (void)removeAnnotation:(id<MKAnnotation>)annotation;

/**
 *  Removes an array of annotation objects from the PWMapView.
 *
 *  @param annotations The array of annotations to remove. Objects in the array must conform to the MKAnnotation protocol.
 */
- (void)removeAnnotations:(NSArray<id<MKAnnotation>> *)annotations;

/**
 *  Adds a single overlay object to the PWMapView.
 *
 *  @param overlay The overlay object to add. This object must conform to the MKOverlay protocol.
 */
- (void)addOverlay:(id<MKOverlay>)overlay;

/**
 *  Adds an array of overlay objects to the PWMapView.
 *
 *  @param overlays An array of objects, each of which must conform to the MKOverlay protocol.
 */
- (void)addOverlays:(NSArray<id<MKOverlay>> *)overlays;

/**
 *  Inserts an overlay object into the list associated with the PWMapView.
 *
 *  @param overlay The overlay object to insert.
 *  @param index The index at which to insert the overlay object.
 */
- (void)insertOverlay:(id<MKOverlay>)overlay atIndex:(NSUInteger)index;

/**
 *  Exchanges the position of two overlay objects.
 *
 *  @param index1 The index of an overlay in the MKOverlayLevelAboveLabels map level.
 *  @param index2 The index of another overlay in the MKOverlayLevelAboveLabels map level.
 */
- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2;

/**
 *  Removes a single overlay object from the PWMapView.
 *
 *  @param overlay The overlay object to remove.
 */
- (void)removeOverlay:(id<MKOverlay>)overlay;

/**
 *  Removes one or more overlay objects from the PWMapView.
 *
 *  @param overlays An array of objects, each of which conforms to the MKOverlay protocol.
 */
- (void)removeOverlays:(NSArray<id<MKOverlay>> *)overlays;

@end
