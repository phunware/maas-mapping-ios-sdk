//
//  MapViewController.h
//  PWMapKit
//
//  Created on 8/15/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>

#define kSegmentBackgroundHeight 56.f
#define kRouteInstructionHeight 75.f

extern NSString * const CurrentUserHeadingUpdatedNotification;
extern NSString * const CurrentUserLocationUpdatedNotification;
extern NSString * const CancelCurrentRouteNotification;
extern NSString * const PlotRouteNotification;

@interface MapViewController : UIViewController <PWMapViewDelegate, PWRouteStartViewDelegate, PWRouteInstructionViewDelegate>

#pragma mark - Properties

// The building is currently loaded in the map
@property (nonatomic, strong) PWBuilding *building;

// Views
@property (nonatomic, strong) PWMapView *mapView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *searchField;

#pragma mark - Methods

/**
 *  Initialization with a `PWBuilding` object.
 *
 *  @param building The `PWBuilding` object
 */
- (instancetype)initWithBuilding:(PWBuilding *)building;

/**
 *  Initialization with a dictionary which contains the building identifier an others.
 *
 *  @param building A `NSDictionary` object
 */
- (instancetype)initWithBuildingConfiguration:(NSDictionary *)configuration;

@end
