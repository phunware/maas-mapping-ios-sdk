//
//  MapViewController+Routing.m
//  Turn-by-Turn
//
//  Created by Phunware on 5/15/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "MapViewController+Routing.h"
#import "PWManeuverListViewController.h"

@implementation MapViewController (Routing)

#pragma mark - Public

- (void)startRoutingToBuildingAnnotation:(PWBuildingAnnotation *)buildingAnnotation {
    // Create options and directions object
    PWDirectionsOptions *options = [PWDirectionsOptions new];
    options.requireAccessibleRoutes = PWDirectionsTypeAny;
    PWDirections *directions = [[PWDirections alloc] initWithWaypoints:@[self.pinDropAnnotation, buildingAnnotation]
                                                               options:options];
    
    __weak typeof(self) weakSelf = self;
    [directions calculateDirectionsWithCompletionHandler:^(PWDirectionsResponse *response, NSError *error) {
        if (!error) {
            PWRoute *route = [response.routes firstObject];
            [weakSelf.mapView plotRoute:route];
            
            // Maneuvers are not plotted by default to preseve backwards compatible behavior
            PWRouteManeuver *firstManeuver = weakSelf.mapView.currentRoute.maneuvers.firstObject;
            [weakSelf displayManeuverInMap:firstManeuver];
            [weakSelf displayRoutingUI];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)cancelRouting {
    [self.mapView cancelRouting];
    
    UIBarButtonItem *floorSwitcherButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"830-stack-1"] style:UIBarButtonItemStylePlain target:self action:@selector(showFloorOptions:)];
    
    
    [self.navigationItem setRightBarButtonItem:floorSwitcherButton animated:NO];
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    
    [self.maneuversController.view removeConstraints:[self.maneuversController.view constraints]];
    [self.maneuversController.view removeFromSuperview];
    [self.maneuversController removeFromParentViewController];
    
    self.maneuversController = nil;
}

#pragma mark - Turn-by-Turn

- (void)displayRoutingUI {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelRouting)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(showManeuverList)];
}

- (void)showManeuverList
{
    PWManeuverListViewController *zoneDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"PWManeuverListViewController"];
    zoneDetails.mapView = self.mapView;
    zoneDetails.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:zoneDetails animated:YES completion:nil];
}

- (void)startTurnByTurnDirections {
    PWTurnByTurnManeuversCollectionViewController *maneuversViewController = [[PWTurnByTurnManeuversCollectionViewController alloc] initWithMapView:self.mapView];
    maneuversViewController.view.translatesAutoresizingMaskIntoConstraints  = NO;
    maneuversViewController.delegate = self;
    
    [self.view addSubview:maneuversViewController.view];
    [self addChildViewController:maneuversViewController];
    self.maneuversController = maneuversViewController;
    
    NSDictionary *views = @{@"maneuversView":maneuversViewController.view,@"layoutGuide":self.topLayoutGuide};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[maneuversView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[layoutGuide]-0-[maneuversView]" options:0 metrics:nil views:views]];
    [maneuversViewController scrollOutOfScreenAnimated:NO];
}

- (void)displayManeuverInMap:(PWRouteManeuver*)maneuver {
    if ([self.mapView currentManeuver] && (maneuver.index == [self.mapView currentManeuver].index)) {
        return;
    }
    
    [self.mapView setRouteManeuver:maneuver];
}


#pragma mark - PWTurnByTurnManeuversCollectionViewControllerDelegate

- (void)turnByTurnManeuversViewDidScrollToManeuver:(PWRouteManeuver *)maneuver triggeredByUser:(BOOL)triggeredByUser {
    if (maneuver) {
        if (triggeredByUser) {
            [self displayManeuverInMap:maneuver];
            if (self.mapView.indoorUserTrackingMode != PWIndoorUserTrackingModeNone)
            {
                self.mapView.indoorUserTrackingMode = PWIndoorUserTrackingModeNone;
            }
        }
        
        // This is probably an appropriate place to perform text-to-speech on maneuver directions
    }
}


#pragma mark - PWMapViewDelegate

- (void)mapView:(PWMapView *)mapView didChangeRouteManeuver:(PWRouteManeuver *)maneuver {
    
    if (!self.maneuversController) {
        [self startTurnByTurnDirections];
    }
    
    [self.maneuversController scrollToManeuver:maneuver animated:YES];
}

@end
