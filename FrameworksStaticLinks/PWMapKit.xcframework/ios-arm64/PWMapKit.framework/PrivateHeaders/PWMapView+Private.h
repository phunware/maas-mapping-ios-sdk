//
//  PWMapView+Private.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>

#import "PWMapView+Building.h"
#import "PWMapView+AnnotationManagement.h"
#import "PWMapView+MapViewDelegation.h"
#import "PWMapView+UserFollowing.h"
#import "PWMapView+UserLocationGovernance.h"
#import "PWMapView+Wayfinding.h"
#import "PWMapView+Occlusion.h"

#import "PWBuilding+Private.h"
#import "PWFloor+Private.h"
#import "PWPointOfInterest+Private.h"
#import "PWCustomPointOfInterest.h"
#import "PWPointOfInterestType+Private.h"
#import "PWRoutingWaypoint.h"
#import "PWUserLocation+Private.h"
#import "PWMapPoint.h"

#import "PWRoute+Private.h"
#import "PWRouteStep+Private.h"
#import "PWRouteInstruction+Private.h"

#import "PWBuildingOverlay+Private.h"
#import "PWRouteInstructionOverlay.h"
#import "PWRouteOverlay.h"
#import "PWRouteInstructionRenderer.h"
#import "PWRouteInstructionDirectionOverlay.h"
#import "PWHideBackgroundOverlay.h"
#import "PWBuildingOverlayRenderer.h"
#import "PWSVPulsingAnnotationView.h"
#import "PWBuildingAnnotationView+Private.h"
#import "PWAnnotationLabel.h"
#import "PWMultiRouteOverlay.h"
#import "PWMultiRouteOverlayRenderer.h"

#import "PWRouteSnapper.h"
#import "PWMapKitAnalytics+Private.h"
#import "PWUserLocationGovernor+Private.h"

#import "PWMapViewDelegateProxy.h"
#import "PWUserLocationGovernorDelegateProtocol.h"
#import "PWLocationSharingDelegate.h"

#import "PWMappingTypes.h"
#import "MapStateFlags.h"
#import "PWMapKitDefines.h"
#import "PWMappingUtilities.h"
#import "PWSystemMacros.h"

#import "PWLocationSharingManager.h"
#import "PWDebugDotManager.h"

#define distance(p1, p2) sqrt(pow(fabs(p1.x - p2.x), 2) + pow(fabs(p1.y - p2.y), 2))

static const PWTrackingMode PWIndoorRoutingUserTrackingMode = PWTrackingModeFollow;

@interface PWMapView () <UIGestureRecognizerDelegate, PWBuildingOverlayDelegateProtocol, PWLocationManagerDelegate, CLLocationManagerDelegate, PWUserLocationGovernorDelegateProtocol, MKMapViewDelegate>

// Delegate
@property (nonatomic) PWMapViewDelegateProxy *delegateProxy;

// Building
//@property PWBuildingIdentifier buildingID;
@property (nonatomic) NSMutableArray *buildingAnnotations;
@property (nonatomic) id<MKAnnotation> selectingAnnotation;
@property (nonatomic) id<MKAnnotation> focusedAnnotation;

// Overlay & Renderer
@property (nonatomic) NSMutableArray<PWBuildingOverlay *> *buildingOverlays;
@property (nonatomic) NSMutableArray<PWBuildingOverlayRenderer *> *buildingRenderers;
@property (nonatomic) PWMultiRouteOverlay *routeOverlay;
@property (nonatomic) PWHideBackgroundOverlay *hideBackgroundOverlay;
@property (nonatomic) PWBuildingOverlay *currentBuildingOverlay;

// Routing
@property (nonatomic) PWRoute *currentRoute;
@property (nonatomic) PWRouteInstruction *currentRouteInstruction;
@property (nonatomic) PWRouteUIOptions *routeUIOptions;
@property (nonatomic) NSDate *lastManeuverSwitchTime;

// Indoor Location
@property (nonatomic) PWUserLocationGovernor *userLocationGovernor;
@property (nonatomic) PWUserLocation *indoorUserLocation;
@property (nonatomic) PWSVPulsingAnnotationView *navigationAnnotationView;
@property (nonatomic) MKCoordinateRegion regionBeforeChanging;
@property (nonatomic) PWDebugDotManager *debugDotManager;
@property (nonatomic) CLLocationDirection lastTrueHeading;

// For updating user location
@property (nonatomic) CADisplayLink *displayLink;

// POI Display Management
@property (nonatomic) MKMapRect lastVisibleMapRect; /** PWMapView+Occlusion **/
@property (nonatomic) NSDate *lastMapRegionChangeTime;

// Loading State Management
@property (nonatomic) MapStateFlags *stateFlags;

// Zoom
@property (nonatomic) double defaultMaximumZoomLevel;
@property (nonatomic, copy) NSNumber *cachedZoomLevel;

// Tracking mode - used to keep the tracking mode which was set by end user.
@property (nonatomic) PWTrackingMode trueTrackingMode;

// Location sharing manager
@property (nonatomic, strong) PWLocationSharingManager *locationSharingManager;

/**
 This property determines whether the `PWPointOfInterest` objects for the current building will be passed through to the `mapView:viewForAnnotation` delegate method. If 'NO', building annotations will be assigned an appropriate `PWBuildingAnnotationView` internally.
 @discussion The default value is `NO`. If you set this property to `YES`, you will have to control the building annotation visibility.
 */
@property (nonatomic) BOOL needCustomizePOIAnnotationView;

/**
 A Boolean value indicating whether the POI's zoom level is respecting Phunware's zoom level.
 @discussion When turned on, POIs respect the Phunware zoom level; when turned off, all POIs display (regardless of Phunware zoom level). This feature is turned on by default.
 */
@property (nonatomic) BOOL annotationZoomLevelsEnabled;

/**
 Time stamp for when route maneuver changed last.
 */
@property (nonatomic) NSTimeInterval lastManeuverChangedTime;

/**
 Timer used to control whether to process route maneuver.
 */
@property (strong, nonatomic) dispatch_source_t routeManeuverProcessingTimer;

- (void)willAppear;
- (void)didDisappear;
- (BOOL)isMapRegionChanging;
- (void)processUserTrackingMode:(PWTrackingMode)trackingMode animated:(BOOL)animated;
- (BOOL)isBuildingOverlayRenderedForFloor:(PWFloor *)floor;
- (PWFloor *)getFloorById:(NSInteger)floorID;
- (PWFloor *)getInitialFloor;

@end
