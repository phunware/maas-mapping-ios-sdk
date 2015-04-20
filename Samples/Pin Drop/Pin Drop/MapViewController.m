//
//  ViewController.m
//  Pin Drop
//
//  Created by Illya Busigin on 4/13/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "MapViewController+PinDrop.h"
#import <PWMapKit/PWDirectionsOptions.h>

@interface MapViewController () <PWMapViewDelegateProtocol, UIActionSheetDelegate>

@end

@implementation MapViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.mapView willAppear];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView.delegate = self;
    [self.mapView toggleZoomWorkaround];
    
    // Load the building
    [self.mapView loadBuildingWithIdentifier:NSNotFound];
    
    // Setup pin drop functionality
    [self setupPinDropRecognizer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.mapView didDisappear];
}


#pragma mark - Actions

- (IBAction)showFloorOptions:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Floor" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (PWBuildingFloor *floor in self.mapView.building.floors)
    {
        [actionSheet addButtonWithTitle:floor.name];
    }
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [actionSheet showFromBarButtonItem:sender animated:YES];
    } else {
        [actionSheet addButtonWithTitle:@"Cancel"];
        [actionSheet setCancelButtonIndex:self.mapView.building.floors.count];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - PWMapViewDelegates

- (void)mapView:(PWMapView *)mapView didFinishLoadingBuilding:(PWBuilding *)building {
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:building.location
                                                     fromEyeCoordinate:building.location
                                                           eyeAltitude:500];
    
    [mapView setCamera:camera animated:NO];
}

- (void)mapView:(PWMapView *)mapView didFailToLoadBuilding:(NSInteger)buildingID error:(NSError *)error {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    UIView *directionsView = [UIButton new];
    directionsView.frame = CGRectMake(0, 0, 38, 80);
    directionsView.backgroundColor = self.view.tintColor;
    
    UIButton *directionsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    directionsButton.tintColor = [UIColor whiteColor];
    directionsButton.frame = CGRectMake(0, 0, 38, 45);
    directionsButton.backgroundColor = self.view.tintColor;
    directionsButton.userInteractionEnabled = NO;
    [directionsButton setImage:[UIImage imageNamed:@"route"] forState:UIControlStateNormal];
    
    [directionsView addSubview:directionsButton];
    
    for (MKAnnotationView *view in views) {
        if ([view isKindOfClass:[PWBuildingAnnotationView class]]) {
            PWBuildingAnnotationView *buildingAnnotationView = (PWBuildingAnnotationView *)view;
            buildingAnnotationView.leftCalloutAccessoryView = directionsView;
            
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if (!self.pinDropAnnotation) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Pin Dropped" message:@"Please drop a pin and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    PWBuildingAnnotation *buildingAnnotation = (PWBuildingAnnotation *)view.annotation;
    
    // Create options and directions object
    PWDirectionsOptions *options = [PWDirectionsOptions new];
    options.requireAccessibleRoutes = PWDirectionsTypeAny;
    PWDirections *directions = [[PWDirections alloc] initWithWaypoints:@[self.pinDropAnnotation, buildingAnnotation]
                                                            options:options];
    
    __weak typeof(self) weakSelf = self;
    [directions calculateDirectionsWithCompletionHandler:^(PWDirectionsResponse *response, NSError *error) {
        if (!error) {
            PWRoute *route = [response.routes firstObject];
            [weakSelf.mapView plotRoute:route];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < self.mapView.building.floors.count) {
        PWBuildingFloor *selectedFloor = self.mapView.building.floors[buttonIndex];
        [self.mapView setCurrentFloor:selectedFloor];
    }
}

@end
