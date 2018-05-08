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

@interface RoutingViewController () <PWMapViewDelegate, CLLocationManagerDelegate>

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
    
    if (self.applicationId.length > 0 && self.accessKey.length > 0 && self.signatureKey.length > 0 && self.buildingIdentifier != 0) {
        [PWCore setApplicationID:self.applicationId accessKey:self.accessKey signatureKey:self.signatureKey];
    } else {
        [NSException raise:@"MissingConfiguration" format:@"applicationId, accessKey, signatureKey, and buildingIdentifier must be set"];
    }
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    self.mapView = [PWMapView new];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self configureMapViewConstraints];
    
    [PWBuilding buildingWithIdentifier:self.buildingIdentifier completion:^(PWBuilding *building, NSError *error) {
        __weak typeof(self) weakSelf = self;
        [weakSelf.mapView setBuilding:building animated:YES onCompletion:^(NSError *error) {
            [weakSelf startManagedLocationManager];
        }];
    }];
}

- (void)startManagedLocationManager {
    PWManagedLocationManager *managedLocationManager = [[PWManagedLocationManager alloc] initWithBuildingId:self.buildingIdentifier];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView registerLocationManager:managedLocationManager];
    });
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
        
        PWPointOfInterest *destinationPOI;
        if (destinationPOIIdentifier != 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %d", destinationPOIIdentifier];
            NSArray *filteredArray = [self.mapView.building.pois filteredArrayUsingPredicate:predicate];
            destinationPOI = [filteredArray firstObject];
        } else {
            destinationPOI = [self.mapView.building.pois firstObject];
        }
        
        if (!destinationPOI) {
            NSLog(@"No points of interest found, please add at least one to the building in the Maas portal");
            return;
        }
        
        [PWRoute createRouteFrom:self.mapView.indoorUserLocation to:destinationPOI accessibility:NO excludedPoints:nil completion:^(PWRoute *route, NSError *error) {
            __weak typeof(self) weakSelf = self;
            
            if (route) {
                [weakSelf.mapView navigateWithRoute:route];
            }
        }];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self startManagedLocationManager];
    } else {
        NSLog(@"Not authorized to start PWManagedLocationManager");
    }
}

@end
