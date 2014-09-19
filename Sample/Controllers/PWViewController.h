//
//  PWViewController.h
//  PWMapKitSample
//
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PWMapKit/PWMapKit.h>
#import <PWLocation/PWLocation.h>
#import <CoreLocation/CoreLocation.h>


typedef NS_ENUM(NSInteger, PWLocationManagerType) {
    PWLocationManagerTypeMSE = 0,
    PWLocationManagerTypeBLE = 1,
    PWLocationManagerTypeMock = 2
};

@interface PWViewController : UIViewController

@property (nonatomic, weak) IBOutlet PWMapView *mapView;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *floorSwitchingBarButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *directionsBarButton;

@property (nonatomic, strong) id<PWLocationManager> locationManager;
@property (nonatomic, strong) NSString *currentBuildingName;

- (void)registerLocationManager:(PWLocationManagerType)locationManagerType;

@end
