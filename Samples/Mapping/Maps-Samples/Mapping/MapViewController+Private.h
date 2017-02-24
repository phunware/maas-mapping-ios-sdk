//
//  MapViewController+Private.h
//  PWMapKit
//
//  Created on 8/22/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PWLocation/PWLocation.h>

#import "MapViewController.h"
#import "RoutingDirectionsTableView.h"
#import "DirectoryController.h"
#import "AroundMeController.h"
#import "RouteController.h"

typedef NS_ENUM(NSUInteger, DirectorySegments) {
    DirectorySegmentsMap = 0,
    DirectorySegmentsDirectory,
    DirectorySegmentsAroundMe
};

@interface MapViewController()

#pragma mark - Views

@property (nonatomic, strong) UIView *segmentBackground;
@property (nonatomic, strong) UISegmentedControl *segments;
@property (nonatomic, strong) PWRouteInstructionsView *routeInstruction;
@property (nonatomic, strong) RoutingDirectionsTableView *routingDirectionsTableView;
@property (nonatomic, strong) UIView *routeHeaderView;

#pragma mark - Constraints

@property (nonatomic, strong) NSLayoutConstraint *searchFieldShrinkConstraint;
@property (nonatomic, strong) NSLayoutConstraint *searchFieldShrinkWithCancelConstraint;
@property (nonatomic, strong) NSLayoutConstraint *searchFieldFullConstraint;
@property (nonatomic, strong) NSLayoutConstraint *defaultSegmentsHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *hideSegmentsHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *tableViewTopConstraint;

#pragma mark - Controllers

@property (nonatomic, strong) DirectoryController *directoryController;
@property (nonatomic, strong) AroundMeController *aroundMeController;
@property (nonatomic, strong) RouteController *routeController;

#pragma mark - Filters
@property (nonatomic, strong) PWFloor *filterFloor;
@property (nonatomic, strong) NSNumber *filterRadius;
@property (nonatomic, strong) PWPointOfInterestType *filterPOIType;

#pragma mark - Bar button Items
@property (nonatomic, strong) UIBarButtonItem *flexibleBarSpace;
@property (nonatomic, strong) UIBarButtonItem *navigationBarButton;
@property (nonatomic, copy) UIBarButtonItem *floorsBarButton;
@property (nonatomic, strong) UIBarButtonItem *categoriesBarButton;
@property (nonatomic, strong) UIBarButtonItem *distanceBarButton;
@property (nonatomic, strong) UIBarButtonItem *cancelBarButton;

@property (nonatomic, strong) NSArray *filteredPOIs;
@property (nonatomic) BOOL isDirectorySegments;

#pragma mark - Methods

- (void)resetMapView;

- (IBAction)btnCancelRoute:(id)sender;

#pragma mark - State

@property (nonatomic, assign) DirectorySegments segmentRoutedFrom; // the segment that was selected before routing started

@end
