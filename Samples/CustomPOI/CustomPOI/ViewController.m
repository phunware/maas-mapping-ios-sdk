//
//  ViewController.m
//  CustomPOI
//
//  Copyright © 2017 Phunware Inc. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PWLocation/PWLocation.h>

#import "ViewController.h"

#define kBuildingIdentifier 0  // Getting from building edit page on Phunware MaaS portal

@interface ViewController() <PWMapViewDelegate>

// Phunware indoor map view
@property (nonatomic, strong) PWMapView *mapView;

// Loading indicator
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add empty indoor map view
    _mapView = [[PWMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    // Add indoor map loading indicator
    _loadingView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
    _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _loadingView.backgroundColor = [UIColor lightGrayColor];
    _loadingView.alpha = 0.8;
    [_loadingView startAnimating];
    [self.view addSubview:_loadingView];
    
    // Load building and set it for indoor map
    __weak typeof(self) weakself = self;
    [PWBuilding buildingWithIdentifier:kBuildingIdentifier completion:^(PWBuilding *building, NSError *error) {
        if (building) {
            // Set building for the map
            [weakself.mapView setBuilding:building animated:YES onCompletion:^(NSError *error) {
                // ======================================
                // Add custom point of interest
                //
                // Important: It has to put after building setting
                //
                // ======================================
                [weakself addCustomPointOfInterest];
                
                // Remove loading indicator
                [weakself.loadingView stopAnimating];
                [weakself.loadingView removeFromSuperview];
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Add custom point of interest

- (void)addCustomPointOfInterest {
    // The (lat, long) for the custom point of interest
    CLLocationCoordinate2D poiLocation = CLLocationCoordinate2DMake(30.359931, -97.742507);
    
    // The floorId for the point of interest. It's only shown on the matched building floor, it's always shown if you set it to `0`.
    NSInteger poiFloorId = 0;
    
    // The buildingId for the point of interest
    NSInteger poiBuildingId = kBuildingIdentifier;
    
    // The point of interest annotation title, it's optional.
    NSString *poiTitle = @"Custom POI";
    
    // The point of interest annotation image, it's optional.
    // If it's nil, SDK checks it `pointOfInterestType` property to use the type icon, and `pointOfInterestType` can be anyone of `building.pointOfInterestTypes`;
    // If `pointOfInterestType` property is still nil, SDK use the default icon at https://lbs-prod.s3.amazonaws.com/stock_assets/icons/0_higher.png
    UIImage *poiIcon = nil;
    
    PWCustomPointOfInterest *customPOI = [[PWCustomPointOfInterest alloc]
                 initWithCoordinate:poiLocation
                 floorId:poiFloorId
                 buildingId:poiBuildingId
                 title:poiTitle
                 image:poiIcon];
    
    // Show the text label under the icon
    customPOI.showTextLabel = YES;
    
    [self.mapView addAnnotation:customPOI];
}


#pragma mark - PWMapViewDelegate

// Tell the custom point of interest is added succssfully
- (void)mapView:(PWMapView *)mapView didAnnotateView:(PWBuildingAnnotationView *)view withPointOfInterest:(PWPointOfInterest *)poi {
    if ([poi isKindOfClass:[PWCustomPointOfInterest class]]) {
        NSLog(@"The custom point of interest is successfully added on the indoor map");
    }
}

@end
