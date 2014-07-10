//
//  PWViewController.h
//  PWMapKitSample
//
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PWMapKit/PWMapKit.h>

@interface PWViewController : UIViewController

@property (nonatomic, weak) IBOutlet PWMapView *mapView;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *floorSwitchingBarButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *directionsBarButton;

@property (nonatomic, strong) NSString *currentBuildingName;

@end
