//
//  ViewController.h
//  Zoom Workaround
//
//  Created by Illya Busigin on 4/13/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PWMapKit/PWMapKit.h>

@interface MapViewController : UIViewController

@property (weak) IBOutlet PWMapView *mapView;
@property (weak) IBOutlet UISwitch *zoomToggleSwitch;

@end

