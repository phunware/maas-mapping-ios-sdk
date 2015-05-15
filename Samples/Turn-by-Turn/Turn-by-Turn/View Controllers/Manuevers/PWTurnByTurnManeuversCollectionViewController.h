//
//  PWManeuversCollectionViewController.h
//  Turn-by-Turn
//
//  Created by Phunware on 4/23/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PWMapKit/PWMapKit.h>
#import <PWMapKit/PWRouteManeuver.h>

#import "PWTurnByTurnManeuversCollectionViewControllerDelegate.h"

@interface PWTurnByTurnManeuversCollectionViewController : UIViewController

@property (readonly, weak) PWMapView *mapView;
@property (readonly, weak) PWRouteManeuver *currentManeuver;
@property (weak) id<PWTurnByTurnManeuversCollectionViewControllerDelegate> delegate;


- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithMapView:(PWMapView *)mapView;

- (void)scrollToManeuver:(PWRouteManeuver*)maneuver animated:(BOOL)animated;

- (void)scrollToManeuverAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)scrollOutOfScreenAnimated:(BOOL)animated;

@end
