//
//  ViewController.h
//  Pin Drop
//
//  Created by Phunware on 4/13/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PWMapKit/PWMapKit.h>
#import <PWLocation/PWLocation.h>

#import "PWPinDropAnnotation.h"
#import "PWTurnByTurnManeuversCollectionViewController.h"

@interface MapViewController : UIViewController

@property PWPinDropAnnotation *pinDropAnnotation;
@property (weak) IBOutlet PWMapView *mapView;

@property PWTurnByTurnManeuversCollectionViewController *maneuversController;

- (IBAction)showFloorOptions:(id)sender;

@end

