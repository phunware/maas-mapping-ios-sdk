//
//  DirectoryController.h
//  PWMapKit
//
//  Created on 8/17/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MapViewController.h"

@interface DirectoryController : NSObject <PWMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *filteredPOIs;
@property (nonatomic, strong) NSArray *sectionedPOIs;

@property (nonatomic, strong) UIBarButtonItem *flexibleBarSpace;
@property (nonatomic, strong) UIBarButtonItem *navigationBarButton;
@property (nonatomic, strong) UIBarButtonItem *floorsBarButton;
@property (nonatomic, strong) UIBarButtonItem *categoriesBarButton;
@property (nonatomic, strong) UIBarButtonItem *distanceBarButton;

@property (nonatomic, strong) PWFloor *filterFloor;
@property (nonatomic, strong) PWPointOfInterestType *filterPOIType;
@property (nonatomic) NSNumber *filterRadius;

@property (nonatomic, strong) MapViewController *mapViewController;
@property (nonatomic, strong) PWBuilding *building;
@property (nonatomic, strong) PWMapView *mapView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *searchField;

- (instancetype)initWithMapViewController:(MapViewController *)viewController;

- (void)loadView;

- (void)adjustViews;

- (void)search:(NSString *)keyword;

- (void)buildSectionedPOIs;

- (UITableViewCell *)cellForPointOfInterest:(PWPointOfInterest *)pointOfInterest tableView:(UITableView *)tableView;

- (void)selectPointOfInterest:(PWPointOfInterest *)pointOfInterest;

@end
