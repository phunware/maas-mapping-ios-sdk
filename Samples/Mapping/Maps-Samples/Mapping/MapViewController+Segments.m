//
//  MapViewController+Segment.m
//  PWMapKit
//
//  Created on 9/6/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PureLayout/PureLayout.h>

#import "MapViewController+Segments.h"
#import "MapViewController+Search.h"
#import "CommonSettings.h"

typedef NS_ENUM(NSUInteger, RouteSegments) {
    RouteSegmentsMap = 0,
    RouteSegmentsList
};

@implementation MapViewController(Segments)

- (void)setupSegments {
    // Segements
    self.segmentBackground = [[UIView alloc] initWithFrame:CGRectZero];
    self.segmentBackground.backgroundColor = [CommonSettings commonNavigationBarBackgroundColor];
    [self.view addSubview:self.segmentBackground];
    [self.segmentBackground autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [self.segmentBackground autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.segmentBackground autoPinEdgeToSuperviewEdge:ALEdgeRight];
    self.defaultSegmentsHeightConstraint = [self.segmentBackground autoSetDimension:ALDimensionHeight toSize:kSegmentBackgroundHeight];
    
    self.isDirectorySegments = YES;
    self.segments = [[UISegmentedControl alloc] initWithItems:@[PWLocalizedString(@"SegmentTitleMap", @"Map"),
                                                            PWLocalizedString(@"SegmentTitleDirectory", @"Directory"),
                                                            PWLocalizedString(@"SegmentTitleAroundMe", @"Around Me")]];
    self.segments.selectedSegmentIndex = DirectorySegmentsMap;
    self.segments.tintColor = [UIColor whiteColor];
    [self.segments addTarget:self action:@selector(switchSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segments];
    [self.segments autoPinToTopLayoutGuideOfViewController:self withInset:12];
    [self.segments autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kStandardSpace];
    [self.segments autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kStandardSpace];
}

- (void)setRouteSegments {
    [self hideSegments:NO];
    
    if (!self.isDirectorySegments) {
        return;
    }
    
    self.isDirectorySegments = NO;
    [self.segments removeAllSegments];
    [self.segments insertSegmentWithTitle:PWLocalizedString(@"SegmentTitleMap", @"Map") atIndex:RouteSegmentsMap animated:NO];
    [self.segments insertSegmentWithTitle:PWLocalizedString(@"SegmentTitleList", @"List") atIndex:RouteSegmentsList animated:NO];
    if (UIAccessibilityIsVoiceOverRunning()) {
        [self.segments setSelectedSegmentIndex:RouteSegmentsList];
    } else {
        [self.segments setSelectedSegmentIndex:RouteSegmentsMap];
    }
    [self switchSegment:self.segments];
}

- (void)setDirectorySegments {
    [self hideSegments:NO];
    
    if (self.isDirectorySegments) {
        return;
    }
    
    self.isDirectorySegments = YES;
    [self.segments removeAllSegments];
    [self.segments insertSegmentWithTitle:PWLocalizedString(@"SegmentTitleMap", @"Map") atIndex:DirectorySegmentsMap animated:NO];
    [self.segments insertSegmentWithTitle:PWLocalizedString(@"SegmentTitleDirectory", @"Directory") atIndex:DirectorySegmentsDirectory animated:NO];
    [self.segments insertSegmentWithTitle:PWLocalizedString(@"SegmentTitleAroundMe", @"Around Me") atIndex:DirectorySegmentsAroundMe animated:NO];
    [self selectSegmentFor:self.segmentRoutedFrom];
}

- (void)hideSegments:(BOOL)hide {
    self.segments.hidden = hide;
    if (hide) {
        [self.defaultSegmentsHeightConstraint setActive:NO];
        self.hideSegmentsHeightConstraint = self.hideSegmentsHeightConstraint ?: [self.segmentBackground autoSetDimension:ALDimensionHeight toSize:0.f];
        [self.hideSegmentsHeightConstraint setActive:YES];
    } else {
        [self.hideSegmentsHeightConstraint setActive:NO];
        [self.defaultSegmentsHeightConstraint setActive:YES];
    }
}

- (void)selectSegmentFor:(DirectorySegments)segment {
    [self.segments setSelectedSegmentIndex:segment];
    [self switchSegment:self.segments];
}

#pragma mark - Actions

- (IBAction)switchSegment:(UISegmentedControl *)sender {
    if (!self.isDirectorySegments) {
        if (sender.selectedSegmentIndex == RouteSegmentsMap) {
            self.routingDirectionsTableView.hidden = YES;
            self.routeInstruction.hidden = NO;
            self.mapView.hidden = NO;
        } else if (sender.selectedSegmentIndex == RouteSegmentsList) {
            self.routingDirectionsTableView.hidden = NO;
            self.routeInstruction.hidden = YES;
            self.mapView.hidden = YES;
        }
        return;
    }
    
    self.segmentRoutedFrom = sender.selectedSegmentIndex;
    [self resetSearch];
    
    switch (sender.selectedSegmentIndex) {
        case DirectorySegmentsMap: {
            [self resetMapView];
            [self shrinkSearchField:YES showCancelButton:NO];
            [self setToolbarItems:@[self.trackingModeView, self.flexibleBarSpace, self.categoriesBarButton, self.flexibleBarSpace, self.floorsBarButton] animated:YES];
            break;
        }
        case DirectorySegmentsDirectory: {
            [self shrinkSearchField:NO showCancelButton:NO];
            [self setToolbarItems:@[self.categoriesBarButton, self.flexibleBarSpace, self.floorsBarButton] animated:YES];
            self.directoryController = self.directoryController ?: [[DirectoryController alloc] initWithMapViewController:self];
            [self.directoryController loadView];
            break;
        }
        case DirectorySegmentsAroundMe: {
            [self shrinkSearchField:NO showCancelButton:NO];
            [self setToolbarItems:@[self.categoriesBarButton, self.flexibleBarSpace, self.distanceBarButton] animated:YES];
            self.aroundMeController = self.aroundMeController ?: [[AroundMeController alloc] initWithMapViewController:self];
            [self.aroundMeController loadView];
            break;
        }
        default:
            break;
    }
}

@end
