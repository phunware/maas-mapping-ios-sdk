//
//  PWRouteViewController.h
//  PWMapKitSample
//
//  Created by Jay on 5/22/14.
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PWMapKit/PWMapKit.h>

@interface PWRouteViewController : UIViewController

// in
@property (nonatomic, weak) PWMapView *mapView;

// out
@property (nonatomic, weak) PWBuildingAnnotation *routeStartPoint;
@property (nonatomic, weak) PWBuildingAnnotation *routeEndPoint;

@end
