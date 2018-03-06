//
//  LoadMapViewController.m
//  MapScenariosObjC
//
//  Created on 3/5/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import "BluedotLocationViewController.h"
#import <PWMapKit/PWMapKit.h>

static NSInteger buildingIdentifier = 0; // Enter your building identifier here, found on the building's Edit page on Maas portal

@interface BluedotLocationViewController () <PWMapViewDelegate>

@property (nonatomic, strong) PWMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL firstLocationAcquired;

@end

@implementation BluedotLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Bluedot Location";
    
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    
    self.mapView = [PWMapView new];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self configureMapViewConstraints];
    
    [PWBuilding buildingWithIdentifier:buildingIdentifier completion:^(PWBuilding *building, NSError *error) {
        __weak typeof(self) weakSelf = self;
        [weakSelf.mapView setBuilding:building animated:YES onCompletion:^(NSError *error) {
            PWManagedLocationManager *managedLocationManager = [[PWManagedLocationManager alloc] initWithBuildingId:buildingIdentifier];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.mapView registerLocationManager:managedLocationManager];
            });
        }];
    }];
}

- (void)configureMapViewConstraints {
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    [[self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
}

#pragma mark - PWMapViewDelegate

- (void)mapView:(PWMapView *)mapView locationManager:(id<PWLocationManager>)locationManager didUpdateIndoorUserLocation:(PWIndoorLocation *)userLocation {
    if (!self.firstLocationAcquired) {
        self.firstLocationAcquired = YES;
        self.mapView.trackingMode = PWTrackingModeFollow;
    }
}

@end
