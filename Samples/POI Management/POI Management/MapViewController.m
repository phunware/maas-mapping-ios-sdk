//
//  ViewController.m
//  POI Management
//
//  Created by Illya Busigin on 4/13/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "MapViewController.h"
#import "POIViewController.h"

@interface MapViewController () <PWMapViewDelegateProtocol>

@end

@implementation MapViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    // Load the building
#warning Replace with with your building identifier!
    NSInteger buildingIdentifier = NSNotFound;
    [self.mapView loadBuildingWithIdentifier:buildingIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.mapView willAppear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.mapView didDisappear];
}

#pragma mark - Actions

- (IBAction)toggledZoomWorkaround:(UISwitch *)zoomToggleSwitch {
    [self.mapView toggleZoomWorkaround];
}

#pragma mark - PWMapViewDelegates

- (void)mapView:(PWMapView *)mapView didFinishLoadingBuilding:(PWBuilding *)building {
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:building.location
                                                     fromEyeCoordinate:building.location
                                                           eyeAltitude:500];
    
    [mapView setCamera:camera animated:NO];
}

- (void)mapView:(PWMapView *)mapView didFailToLoadBuilding:(NSInteger)buildingID error:(NSError *)error {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender == self.navigationItem.rightBarButtonItem) {
        UINavigationController *navigationController = segue.destinationViewController;
        POIViewController *pointOfInterestViewController = (POIViewController *)navigationController.topViewController;
        
        pointOfInterestViewController.mapView = self.mapView;
    }
}

@end