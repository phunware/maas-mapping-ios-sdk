//
//  MapViewController+Pin_Drop.m
//  Pin Drop
//
//  Created by Phunware on 4/13/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "MapViewController+PinDrop.h"

@implementation MapViewController (PinDrop)

#pragma mark - Setup

- (void)setupPinDropRecognizer {
    UILongPressGestureRecognizer *pinDropRecognizer =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinDropRecognizer:)];
    pinDropRecognizer.minimumPressDuration = 0.5;
    
    [self.mapView addGestureRecognizer:pinDropRecognizer];
}


#pragma mark - Actions

- (void)handlePinDropRecognizer:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    [self.mapView removeAnnotation:self.pinDropAnnotation];
    self.pinDropAnnotation = nil;
    
    CGPoint location = [recognizer locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
    if (self.mapView.isUsingZoomWorkaround) {
        coordinate = [self.mapView coordinateFromZoomWorkaroundCoordinate:coordinate];
    }
    
    PWPinDropAnnotation *annotation = [PWPinDropAnnotation new];
    annotation.coordinate = coordinate;
    annotation.floorID = self.mapView.currentFloor.floorID;
    annotation.mapView = self.mapView;
    
    self.pinDropAnnotation = annotation;
    [self.mapView addAnnotation:self.pinDropAnnotation];
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isEqual:self.pinDropAnnotation]) {
        MKPinAnnotationView *view = (MKPinAnnotationView*) [mapView dequeueReusableAnnotationViewWithIdentifier:@"DROPPED_PIN"];
        
        if (!view) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"DROPPED_PIN"];
            view.animatesDrop = YES;
            view.canShowCallout = YES;
        }
        
        view.pinColor = MKPinAnnotationColorRed;
        return view;
    }
    
    return nil;
}

@end
