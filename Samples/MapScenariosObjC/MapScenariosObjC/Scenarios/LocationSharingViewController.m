//
//  LocationSharingViewController.m
//  MapScenariosObjC
//
//  Created on 3/13/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PWCore/PWCore.h>
#import <Foundation/Foundation.h>

#import "LocationSharingViewController.h"

static NSString * const didUpdateAnnotationNotificationName = @"didUpdateAnnotation";
static NSString * const deviceDisplayNameKey = @"DeviceDisplayNameKey";
static NSString * const deviceTypeKey = @"DeviceTypeKey";

#pragma mark - NSNumber Random Value Category

@implementation NSNumber (Random)

+ (CGFloat)randomCGFloat {
    return (CGFloat)arc4random() / (CGFloat)UINT32_MAX;
}

@end

#pragma mark - SharedLocationAnnotation

@interface SharedLocationAnnotation : MKPointAnnotation

@property (nonatomic, strong) PWSharedLocation *sharedLocation;

- (id)initWithSharedLocation:(PWSharedLocation *)sharedLocation;

@end

@implementation SharedLocationAnnotation

- (id)initWithSharedLocation:(PWSharedLocation *)sharedLocation {
    if (self = [super init]) {
        _sharedLocation = sharedLocation;
    }
    return self;
}

@end

#pragma mark - SharedLocationAnnotationView

@interface SharedLocationAnnotationView : MKAnnotationView

@property (nonatomic, strong) UILabel *floatingTextLabel;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier color:(UIColor *)color;

@end

@implementation SharedLocationAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier color:(UIColor *)color {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateAnnotation) name:didUpdateAnnotationNotificationName object:nil];
        
        [self configureFloatingTextLabel];
        
        self.image = [self circleImageWithColor:color height:15.0];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureFloatingTextLabel {
    self.floatingTextLabel = [UILabel new];
    
    [self addSubview:self.floatingTextLabel];
    self.floatingTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [[self.floatingTextLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
    [[self.floatingTextLabel.topAnchor constraintEqualToAnchor:self.bottomAnchor constant:-5.0] setActive:YES];
}

- (UIImage *)circleImageWithColor:(UIColor *)color height:(CGFloat)height {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(height, height), NO, 0);
    UIBezierPath *fillPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, height, height)];
    [color setFill];
    [fillPath fill];
    
    UIImage *dotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return dotImage;
}

- (void)didUpdateAnnotation {
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak typeof(self) weakSelf = self;
        NSString *displayName = ((SharedLocationAnnotation *)weakSelf.annotation).sharedLocation.displayName;
        NSString *userType = ((SharedLocationAnnotation *)weakSelf.annotation).sharedLocation.userType;
        weakSelf.floatingTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", displayName, userType];
    });
}

@end

#pragma mark - LocationSharingViewController

@interface LocationSharingViewController () <PWMapViewDelegate, PWLocationSharingDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) PWMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL firstLocationAcquired;

@property (nonatomic, strong) NSSet<PWSharedLocation *> *sharedLocations;
@property (nonatomic, strong) NSMutableDictionary<NSString *, SharedLocationAnnotation *> *sharedLocationAnnotations;

@property (nonatomic, strong) NSMutableDictionary<NSString *, UIColor *> *annotationColors;

@end

@implementation LocationSharingViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _buildingIdentifier = 0; // Enter your building identifier here, found on the building's Edit page on Maas portal
        // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
        _applicationId = @"";
        _accessKey = @"";
        _signatureKey = @"";
        
        _sharedLocationAnnotations = [NSMutableDictionary new];
        _annotationColors = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Location Sharing";
    
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
    self.mapView.locationSharingDelegate = self;
    self.mapView.sharedLocationDisplayName = [self deviceDisplayName];
    self.mapView.sharedLocationUserType = [self deviceType];
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
        [self.mapView startSharingUserLocation];
        [self.mapView startRetrievingSharedLocations];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsTapped)];
    });
}

- (void)configureMapViewConstraints {
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    [[self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
}

- (SharedLocationAnnotationView *)sharedLocationAnnotationView:(SharedLocationAnnotation *)sharedLocationAnnotation mapView:(MKMapView *)mapView {
    SharedLocationAnnotationView *dotView = (SharedLocationAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:sharedLocationAnnotation.sharedLocation.deviceId];
    
    if (dotView == nil) {
        UIColor *color = [UIColor blackColor];
        UIColor *oldColor = self.annotationColors[sharedLocationAnnotation.sharedLocation.deviceId];
        if (oldColor) {
            color = oldColor;
        } else {
            color = [UIColor colorWithRed:[NSNumber randomCGFloat] green:[NSNumber randomCGFloat] blue:[NSNumber randomCGFloat] alpha:1.0];
            self.annotationColors[sharedLocationAnnotation.sharedLocation.deviceId] = color;
        }
        
        dotView = [[SharedLocationAnnotationView alloc] initWithAnnotation:sharedLocationAnnotation reuseIdentifier:sharedLocationAnnotation.sharedLocation.deviceId color:color];
        dotView.floatingTextLabel.text = sharedLocationAnnotation.title;
    }
    
    return dotView;
}

#pragma mark Setters and Getters

- (void)setDeviceDisplayName:(NSString *)deviceDisplayName {
    self.mapView.sharedLocationDisplayName = deviceDisplayName;
    [[NSUserDefaults standardUserDefaults] setObject:deviceDisplayName forKey:deviceDisplayNameKey];
}

- (NSString *)deviceDisplayName {
    NSString *deviceDisplayName = [[NSUserDefaults standardUserDefaults] objectForKey:deviceDisplayNameKey];
    if (deviceDisplayName) {
        return deviceDisplayName;
    }
    return @"Test";
}

- (void)setDeviceType:(NSString *)deviceType {
    self.mapView.sharedLocationUserType = deviceType;
    [[NSUserDefaults standardUserDefaults] setObject:deviceType forKey:deviceTypeKey];
}

- (NSString *)deviceType {
    NSString *deviceType = [[NSUserDefaults standardUserDefaults] objectForKey:deviceTypeKey];
    if (deviceType) {
        return deviceType;
    }
    return @"Employee";
}

#pragma mark PWMapViewDelegate

- (void)mapView:(PWMapView *)mapView locationManager:(id<PWLocationManager>)locationManager didUpdateIndoorUserLocation:(PWUserLocation *)userLocation {
    if (!self.firstLocationAcquired) {
        self.firstLocationAcquired = YES;
        self.mapView.trackingMode = PWTrackingModeFollow;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    return [self sharedLocationAnnotationView:(SharedLocationAnnotation *)annotation mapView:mapView];
}

#pragma mark PWLocationSharingDelegate

- (void)didUpdateSharedLocations:(NSSet<PWSharedLocation *> *)sharedLocations {
    self.sharedLocations = sharedLocations;
    
    for (PWSharedLocation *updatedSharedLocation in sharedLocations) {
        SharedLocationAnnotation *annotation = self.sharedLocationAnnotations[updatedSharedLocation.deviceId];
        if (annotation != nil) {
            annotation.sharedLocation = updatedSharedLocation;
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    annotation.title = [NSString stringWithFormat:@"%@ (%@)", updatedSharedLocation.displayName, updatedSharedLocation.userType];
                    annotation.coordinate = updatedSharedLocation.location;
                }];
            });
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:didUpdateAnnotationNotificationName object:nil];
}

- (void)didAddSharedLocations:(NSSet<PWSharedLocation *> *)addedSharedLocations {
    for (PWSharedLocation *addedSharedLocation in addedSharedLocations) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SharedLocationAnnotation *annotation = [[SharedLocationAnnotation alloc] initWithSharedLocation:addedSharedLocation];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", addedSharedLocation.displayName, addedSharedLocation.userType];
            annotation.coordinate = addedSharedLocation.location;
            
            __weak typeof(self) weakSelf = self;
            weakSelf.sharedLocationAnnotations[addedSharedLocation.deviceId] = annotation;
            [weakSelf.mapView addAnnotation:annotation];
        });
    }
}

- (void)didRemoveSharedLocations:(NSSet<PWSharedLocation *> *)removedSharedLocations {
    for (PWSharedLocation *removedSharedLocation in removedSharedLocations) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __weak typeof(self) weakSelf = self;
            SharedLocationAnnotation *annotation = weakSelf.sharedLocationAnnotations[removedSharedLocation.deviceId];
            if (annotation) {
                [weakSelf.mapView removeAnnotation:annotation];
                [weakSelf.sharedLocationAnnotations removeObjectForKey:removedSharedLocation.deviceId];
            }
        });
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

#pragma mark Settings Button

- (void)settingsTapped {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set device name and type" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __weak typeof(self) weakSelf = self;
        weakSelf.deviceDisplayName = alertController.textFields[0].text;
        weakSelf.deviceType = alertController.textFields[1].text;
    }];
    [alertController addAction:okayAction];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        __weak typeof(self) weakSelf = self;
        textField.text = weakSelf.deviceDisplayName;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        __weak typeof(self) weakSelf = self;
        textField.text = weakSelf.deviceType;
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
