//
//  PWRouteViewController.h
//  PWMapKitSample
//
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PWMapKit/PWMapKit.h>

@interface PWRouteViewController : UIViewController

// in
@property (nonatomic, weak) PWMapView *mapView;

// out
@property (nonatomic, strong) PWBuildingAnnotation *routeStartPoint;
@property (nonatomic, strong) PWBuildingAnnotation *routeEndPoint;
@property BOOL shouldUseAccessibleRoutes;

@end
