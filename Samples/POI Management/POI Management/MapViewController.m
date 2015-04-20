//
//  ViewController.m
//  POI Management
//
//  Created by Illya Busigin on 4/13/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <PWMapViewDelegateProtocol>

@end

@implementation MapViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.mapView willAppear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    // Load the building
    NSInteger buildingIdentifier = NSNotFound; // Replace with with your building identifier
    [self.mapView loadBuildingWithIdentifier:buildingIdentifier];
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

@end