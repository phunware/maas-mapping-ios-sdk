//
//  PWMapKit.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PWMapKit/PWMapView.h>
#import <PWMapKit/PWSVPulsingAnnotationView.h>
#import <PWMapKit/PWUserTrackingBarButtonItem.h>
#import <PWMapKit/PWIndoorUserTracking.h>
#import <PWMapKit/PWAnnotationProtocol.h>
#import <PWMapKit/PWAnnotationType.h>
#import <PWMapKit/PWBuilding.h>
#import <PWMapKit/PWBuildingAnnotationProtocol.h>
#import <PWMapKit/PWBuildingAnnotationView.h>
#import <PWMapKit/PWBuildingAnnotation.h>
#import <PWMapKit/PWBuildingManager.h>
#import <PWMapKit/PWBuildingFloor.h>
#import <PWMapKit/PWBuildingFloorResource.h>
#import <PWMapKit/PWBuildingFloorReference.h>
#import <PWMapKit/PWBuildingOverlay.h>
#import <PWMapKit/PWBuildingOverlayRenderer.h>
#import <PWMapKit/PWMapDocument.h>
#import <PWMapKit/PWDirections.h>
#import <PWMapKit/PWDirectionsRequest.h>
#import <PWMapKit/PWDirectionsResponse.h>
#import <PWMapKit/PWRoute.h>
#import <PWMapKit/PWRouteStep.h>
#import <PWMapKit/PWRouteAnnotation.h>
#import <PWMapKit/PWAnnotationLabel.h>

/**
 The `PWMapKit` framework provides an interface for embedding indoor maps directly into your own windows and views. This framework also provides support for annotating the map, finding your location, fetching routes, drawing routes and more.
 */

@interface PWMapKit : NSObject

///----------------------
/// @name Utility Methods
///----------------------

/**
 Returns PWMapKit.
 */
+ (NSString *)serviceName;

+ (BOOL)shouldUseZoomWorkaround;
+ (void)setShouldUseZoomWorkaround:(BOOL)useZoom;

@end
