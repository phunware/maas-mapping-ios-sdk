//
//  ViewController.m
//  LoadMap
//
//  Created on 7/25/16.
//  Copyright © 2016 Phunware Inc. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PWLocation/PWLocation.h>

#import "ViewController.h"

#define kBuildingIdentifier 0

@interface ViewController () <PWMapViewDelegate>

@property (nonatomic, strong) PWMapView *mapView;
@property (nonatomic, assign) BOOL firstLocationAcquired;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [PWMapView new];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self configureMapViewConstraints];
    
    __weak typeof(self) weakSelf = self;
    [PWBuilding buildingWithIdentifier:kBuildingIdentifier completion:^(PWBuilding *building, NSError *error) {
        [weakSelf.mapView setBuilding:building];
        
        PWManagedLocationManager *managedLocationManager = [[PWManagedLocationManager alloc] initWithBuildingId:kBuildingIdentifier];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.mapView registerLocationManager:managedLocationManager];
        });
    }];
}

- (void)configureMapViewConstraints {
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

- (void)mapView:(PWMapView *)mapView locationManager:(id<PWLocationManager>)locationManager didUpdateIndoorUserLocation:(PWIndoorLocation *)userLocation {
    if (!self.firstLocationAcquired) {
        self.firstLocationAcquired = YES;
        mapView.trackingMode = PWTrackingModeFollow;
    }
}

@end
