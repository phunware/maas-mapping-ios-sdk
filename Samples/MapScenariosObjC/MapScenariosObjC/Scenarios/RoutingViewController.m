//
//  RoutingViewController.m
//  MapScenariosObjC
//
//  Created on 3/7/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PWCore/PWCore.h>

#import "RoutingViewController.h"

@interface RoutingViewController () <PWMapViewDelegate>

@property (nonatomic, strong) NSString *applicationId;
@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *signatureKey;

@property (nonatomic, strong) PWMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL firstLocationAcquired;

@end

@implementation RoutingViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _buildingIdentifier = 0; // Enter your building identifier here, found on the building's Edit page on Maas portal
        // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
        _applicationId = @"";
        _accessKey = @"";
        _signatureKey = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Route to Point of Interest";
    
    if (self.applicationId.length > 0 && self.accessKey.length > 0 && self.signatureKey.length > 0) {
        [PWCore setApplicationID:self.applicationId accessKey:self.accessKey signatureKey:self.signatureKey];
    }
    
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    
    self.mapView = [PWMapView new];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self configureMapViewConstraints];
    
    [PWBuilding buildingWithIdentifier:self.buildingIdentifier completion:^(PWBuilding *building, NSError *error) {
        __weak typeof(self) weakSelf = self;
        [weakSelf.mapView setBuilding:building animated:YES onCompletion:^(NSError *error) {
            PWManagedLocationManager *managedLocationManager = [[PWManagedLocationManager alloc] initWithBuildingId:weakSelf.buildingIdentifier];
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
        
        NSInteger destinationPOIIdentifier = 0; /* Replace with the destination POI identifier */
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %d", destinationPOIIdentifier];
        NSArray *filteredArray = [self.mapView.building.pois filteredArrayUsingPredicate:predicate];
        
        PWPointOfInterest *pointOfInterest = [filteredArray firstObject];
        if (!pointOfInterest) {
            NSLog(@"You specified `destinationPOIIdentifier = %@` POI not found", @(destinationPOIIdentifier));
            return;
        }
        
        [PWRoute createRouteFrom:self.mapView.indoorUserLocation to:pointOfInterest accessibility:NO excludedPoints:nil completion:^(PWRoute *route, NSError *error) {
            __weak typeof(self) weakSelf = self;
            
            if (route) {
                [weakSelf.mapView navigateWithRoute:route];
            }
        }];
    }
}

@end
