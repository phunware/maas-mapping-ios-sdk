//
//  MapPreviewTableViewCell.m
//  PWMapKit
//
//  Created on 8/18/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PureLayout/PureLayout.h>

#import "MapPreviewTableViewCell.h"

NSString * const MapPreviewTableViewCellReuseIdentifier = @"MapPreviewTableViewCellReuseIdentifier";

@interface MapPreviewTableViewCell () <PWMapViewDelegate>

@property (nonatomic, strong) PWMapView *mapView;
@property (nonatomic, strong) PWRoute *route;
@property (nonatomic, assign) BOOL routeAlreadyStarted;

@end

@implementation MapPreviewTableViewCell

- (void)configureForRoute:(PWRoute *)route mapView:(PWMapView *)mapView {
    self.route = route;
    self.mapView = mapView;
    self.routeAlreadyStarted = NO;
    
    if (![self.mapView isDescendantOfView:self]) {
        [self addSubview:self.mapView];
        [self.mapView autoPinEdgesToSuperviewEdges];
    }
    
    self.mapView.delegate = self;
    self.mapView.userInteractionEnabled = NO;
}

#pragma mark - PWMapView Delegate

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    if (!self.routeAlreadyStarted) {
        self.routeAlreadyStarted = YES;
        [self.mapView setFloor:self.route.startPointOfInterest.floor];
        [self.mapView navigateWithRoute:self.route];
    }
}

@end
