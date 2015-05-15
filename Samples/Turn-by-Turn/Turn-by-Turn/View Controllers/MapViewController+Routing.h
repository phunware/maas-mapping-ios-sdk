//
//  MapViewController+Routing.h
//  Turn-by-Turn
//
//  Created by Phunware on 5/15/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "MapViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <PWMapKit/PWDirectionsOptions.h>

@interface MapViewController (Routing) <PWTurnByTurnManeuversCollectionViewControllerDelegate>

- (void)startRoutingToBuildingAnnotation:(PWBuildingAnnotation *)annotation;
- (void)cancelRouting;

@end
