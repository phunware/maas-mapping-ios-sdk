//
//  LocationModesViewController.m
//  MapScenariosObjC
//
//  Created on 3/6/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PWCore/PWCore.h>

#import "LocationModesViewController.h"

@implementation UIImage (TrackingMode)

+ (UIImage *)emptyTrackingImage:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 26, 26);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    UIBezierPath *bezierPath = [UIBezierPath new];
    [bezierPath moveToPoint:CGPointMake(13.53, 24)];
    [bezierPath addLineToPoint:CGPointMake(13.44, 10.62)];
    [bezierPath addLineToPoint:CGPointMake(0, 10.71)];
    [bezierPath addLineToPoint:CGPointMake(24, 0)];
    [bezierPath addLineToPoint:CGPointMake(13.53, 24)];
    [bezierPath closePath];
    [bezierPath moveToPoint:CGPointMake(14.31, 9.74)];
    [bezierPath addLineToPoint:CGPointMake(14.38, 19.85)];
    [bezierPath addLineToPoint:CGPointMake(22.29, 1.7)];
    [bezierPath addLineToPoint:CGPointMake(4.16, 9.81)];
    [bezierPath addLineToPoint:CGPointMake(14.31, 9.74)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    [color setFill];
    [bezierPath fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)filledTrackingImage:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 26, 26);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    UIBezierPath *bezierPath = [UIBezierPath new];
    [bezierPath moveToPoint:CGPointMake(12.4, 22)];
    [bezierPath addLineToPoint:CGPointMake(12.33, 9.74)];
    [bezierPath addLineToPoint:CGPointMake(0, 9.81)];
    [bezierPath addLineToPoint:CGPointMake(22, 0)];
    [bezierPath addLineToPoint:CGPointMake(12.4, 22)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    [color setFill];
    [bezierPath fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)trackWithHeadingImage:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 26, 26);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    UIBezierPath *bezierPath = [UIBezierPath new];
    [bezierPath moveToPoint:CGPointMake(6.98, 0)];
    [bezierPath addLineToPoint:CGPointMake(8, 0)];
    [bezierPath addLineToPoint:CGPointMake(8, 6.01)];
    [bezierPath addLineToPoint:CGPointMake(6.98, 6.01)];
    [bezierPath addLineToPoint:CGPointMake(6.98, 0)];
    [bezierPath closePath];
    [bezierPath moveToPoint:CGPointMake(7.44, 19.01)];
    [bezierPath addLineToPoint:CGPointMake(0, 26)];
    [bezierPath addLineToPoint:CGPointMake(7.39, 8.01)];
    [bezierPath addLineToPoint:CGPointMake(15, 25.91)];
    [bezierPath addLineToPoint:CGPointMake(7.44, 19.01)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    [color setFill];
    [bezierPath fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@interface LocationModesViewController () <PWMapViewDelegate>

@property (nonatomic, strong) NSString *applicationId;
@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *signatureKey;

@property (nonatomic, strong) PWMapView *mapView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trackingModeButton;

@end

@implementation LocationModesViewController

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
    
    self.navigationItem.title = @"Location Modes";
    
    if (self.applicationId.length > 0 && self.accessKey.length > 0 && self.signatureKey.length > 0) {
        [PWCore setApplicationID:self.applicationId accessKey:self.accessKey signatureKey:self.signatureKey];
    }
    
    self.mapView = [PWMapView new];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self configureMapViewConstraints];
    
    self.trackingModeButton.image = [UIImage emptyTrackingImage:[UIColor blueColor]];
    
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
    [[self.mapView.bottomAnchor constraintEqualToAnchor:self.toolbar.topAnchor] setActive:YES];
    [[self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
}

- (IBAction)trackingModeButtonTapped:(id)sender {
    switch (self.mapView.trackingMode) {
        case PWTrackingModeNone:
            self.mapView.trackingMode = PWTrackingModeFollow;
            break;
        case PWTrackingModeFollow:
            self.mapView.trackingMode = PWTrackingModeFollowWithHeading;
            break;
        case PWTrackingModeFollowWithHeading:
            self.mapView.trackingMode = PWTrackingModeNone;
            break;
        default:
            break;
    }
}

#pragma mark - PWMapViewDelegate

- (void)mapView:(PWMapView *)mapView didChangeIndoorUserTrackingMode:(PWTrackingMode)mode {
    switch (mode) {
        case PWTrackingModeNone:
            self.trackingModeButton.image = [UIImage emptyTrackingImage:[UIColor blueColor]];
            break;
        case PWTrackingModeFollow:
            self.trackingModeButton.image = [UIImage filledTrackingImage:[UIColor blueColor]];
            break;
        case PWTrackingModeFollowWithHeading:
            self.trackingModeButton.image = [UIImage trackWithHeadingImage:[UIColor blueColor]];
            break;
        default:
            break;
    }
}

@end
