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

/**
 *  Supported Location providers types.
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
     *  Route Snapping hihg.
     */
    PWRouteSnapToleranceHigh
};



extern NSString *const PWMapViewLocationTypeFloorMapping;
extern NSString *const PWMapViewLocationTypeMSEVenueGUIDKey;
extern NSString *const PWMapViewLocationTypeBLEMapIdentifierKey;
extern NSString *const PWMapViewLocationTypeBLECustomIdentifierKey;

extern NSString *const PWRouteInstructionChangedNotificationKey;

@class PWMapView;

/**
 *  PWMapViewDelegate protocol definition
 */
@protocol PWMapViewDelegate <NSObject>
@optional

/**
 *  This delegate is called prior to an annotation being displayed. The SDK user has the opportunity to modify the UI of the annotation; such as left/right/detail views and call outs.
 *
 *  @param mapView The current map view instance.
 *  @param view    The annotation view tapped.
 *  @param poi     The point of iterest represented by the annotation.
 */
- (void) mapView:(PWMapView *)mapView didAnnotateView:(MKAnnotationView *)view withPointOfInterest:(PWPointOfInterest *)poi;

/**
 *  This delegate is called when a UIControl (UIButton, etc) is tapped on the custom annotation.
 *
 *  @param mapView The current map view instance.
 *  @param view    The annotation view tapped.
 *  @param control The callout accessory control tapped.
 *  @param poi     The point of iterest represented by the annotation.
 */
- (void) mapView:(PWMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control withPointOfInterest:(PWPointOfInterest *)poi;

/**
 *  This delegate is called when the map view has finished rendering the map.
 *
 *  @param mapView       The current map view instance.
 *  @param fullyRendered BOOL value to tell if the map view has been fully rendered.
 */
- (void) mapViewDidFinishRenderingMap:(MKMapView *)mapView
                       fullyRendered:(BOOL)fullyRendered;

/**
 *  This delegate is called when the the route instruction for the map has changed.
 *
 *  @param mapView          The current map view instance.
 *  @param routeInstruction The new route instruction.
 */
- (void)mapView:(PWMapView *)mapView didChangeRouteInstruction:(PWRouteInstruction *)routeInstruction;

@end

/**
 *  The PWMapClass displays a building structure in an MKMapKit environment.
 */
@interface PWMapView : UIView

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  The receiver’s delegate.
 */
@property (nonatomic) id<PWMapViewDelegate> delegate;

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
 *  A reference to the current custom location after the map view has been asked to navigate to a custom location (Current user position or a Dropped Pin).
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

/**---------------------------------------------------------------------------------------
 * @name Instance Methods
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Sets the location provider to be used by the map.
 *
 *  @param mapViewLocationType The location provider to use. See PWMapViewLocationType for a list of supported location providers.
 *  @param configuration       NSDictionary of configuration key/values. Each Location Type defines its own expected values.
 */
- (void) setMapViewLocationType:(PWMapViewLocationType) mapViewLocationType configuration:(NSDictionary *) configuration;

/**
 *  Sets the building object to be used by the map.
 *
 *  @param building The valid building object to display.
 */
- (void) setBuilding:(PWBuilding *)building;

/**
 *  Sets the current floor of the building that should be displayed on the map.
 *
 *  @param floor The floor object to display
 */
- (void) setFloor:(PWFloor *) floor;

/**
 *  Repositions the map's view to a custom location.
 *
 *  @param location A custom location reference where the map should navigate to.
 */
- (void) navigateToCustomLocation:(PWCustomLocation *) location;

/**
 *  Repositions the map's view to an specific point of interest.
 *
 *  @param poi A point of interest reference where the map should navigate to.
 */
- (void) navigateToPointOfInterest:(PWPointOfInterest *) poi;

/**
 *  Displays the array of Points of Interest, causing the map view to zoom in/out to contain all of the points of interest.
 *
 *  @param pois An array of PWPointOfInterest objects that should be displayed on the map.
 */
- (void) showPointsOfInterest:(NSArray *) pois;

/**
 *  Repositions the map view to display the given route.
 *
 *  @param route The route object that will be used to navigate within the map.
 */
- (void) navigateWithRoute:(PWRoute *)route;

/**
 *  Sets and dislays the current navitation instruction/steps during a navigation.
 *
 *  @param instruction A route instruction object for the route.
 */
- (void) setRouteManeuver:(PWRouteInstruction *)instruction;

/**
 *  Stops the current routing task.
 */
- (void) cancelRouting;

/**
 *  Positions the map to the supplied center coordinate with the given zoom level and optional animation.
 *
 *  @param centerCoordinate A CLLocationCoordinate2D object representing the latitude an longitude the map should zoom to.
 *  @param zoomLevel        A NSUInteger value representing zoom level the map should zoom to.
 *  @param animated         A BOOL property to determine whether the change of map's center should be animated or not.
 */
- (void) setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
