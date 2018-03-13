//
//  CustomPOIViewController.m
//  MapScenariosObjC
//
//  Created on 3/7/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PWCore/PWCore.h>

#import "CustomPOIViewController.h"

@interface CustomPOIViewController ()

@property (nonatomic, strong) PWMapView *mapView;

@end

@implementation CustomPOIViewController

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
    
    self.navigationItem.title = @"Create Custom POI";
    
    if (self.applicationId.length > 0 && self.accessKey.length > 0 && self.signatureKey.length > 0 && self.buildingIdentifier != 0) {
        [PWCore setApplicationID:self.applicationId accessKey:self.accessKey signatureKey:self.signatureKey];
    } else {
        [NSException raise:@"MissingConfiguration" format:@"applicationId, accessKey, signatureKey, and buildingIdentifier must be set"];
    }
    
    self.mapView = [PWMapView new];
    [self.view addSubview:self.mapView];
    [self configureMapViewConstraints];
    
    [PWBuilding buildingWithIdentifier:self.buildingIdentifier completion:^(PWBuilding *building, NSError *error) {
        __weak typeof(self) weakSelf = self;
        [weakSelf.mapView setBuilding:building animated:YES onCompletion:^(NSError *error) {
            [weakSelf addCustomPointOfInterest];
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

- (void)addCustomPointOfInterest {
    // The (lat, long) for the custom point of interest
    CLLocationCoordinate2D poiLocation = CLLocationCoordinate2DMake(30.359931, -97.742507);
    
    // The custom point of interest will only show on the floor identifier specified here, or it will display on all floors if set to 0
    NSInteger poiFloorId = 0;
    
    NSString *poiTitle = @"Custom POI";
    
    // If the image parameter is nil, it will use the POI icon for any specified `pointOfInterestType`. If no image is set and no `pointOfInterestType` is set, the SDK will use this default icon: https://lbs-prod.s3.amazonaws.com/stock_assets/icons/0_higher.png
    PWCustomPointOfInterest *customPOI = [[PWCustomPointOfInterest alloc] initWithCoordinate:poiLocation floorId:poiFloorId buildingId:self.buildingIdentifier title:poiTitle image:nil];
    
    customPOI.showTextLabel = YES;
    
    [self.mapView addAnnotation:customPOI];
}

@end
