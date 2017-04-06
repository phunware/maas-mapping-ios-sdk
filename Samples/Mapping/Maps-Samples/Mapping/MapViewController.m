//
//  MapViewController.m
//  PWMapKit
//
//  Created on 8/15/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "MapViewController+Private.h"
#import "MapViewController+Search.h"
#import "MapViewController+Segments.h"
#import "CommonSettings.h"
#import "RoutingDirectionsTableView.h"
#import "DirectoryController.h"
#import "AroundMeController.h"
#import "RouteController.h"
#import "PreRoutingViewController.h"
#import "PWRouteInstruction+Helper.h"
#import "PWBuilding+Helper.h"
#import "RouteInstructionsView.h"
#import "POITypeViewController.h"

// Remove for external sample
#import "FBBuildingManager.h"

NSString * const CurrentUserHeadingUpdatedNotification = @"CurrentUserHeadingUpdated";
NSString * const CurrentUserLocationUpdatedNotification = @"CurrentUserLocationUpdated";
NSString * const CancelCurrentRouteNotification = @"CancelCurrentRouteNotification";
NSString * const PlotRouteNotification = @"PlotRouteNotification";

const CGFloat RouteInstructionHeight = 75.0f;

@interface MapViewController () <RouteInstructionViewDelegate, POITypeViewControllerDelegate>

@property (nonatomic, assign) long buildingId;
@property (nonatomic, strong) NSDictionary *configuration;

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@property (nonatomic, strong) NSTimer *offRouteTimer;
@property (nonatomic, assign) BOOL offeredToRecalculateRoute;

@property (nonatomic, assign) BOOL mapViewFinishedRendering;
@property (nonatomic, assign) BOOL buildingFinishedLoading;
@property (nonatomic, assign) BOOL directoryWasAutoSelected;
@property (nonatomic, assign) BOOL userWasInformedOfReachingDestination;
@property (nonatomic, assign) BOOL zoomWasSetWhenLocationWasFound;

@end

@implementation MapViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _filterRadius = kDefaultSearchRadius;
    }
    
    return self;
}

- (instancetype)initWithBuilding:(PWBuilding *)building {
    self = [self init];
    if (self) {
        _building = building;
    }
    
    return self;
}

- (instancetype)initWithBuildingConfiguration:(NSDictionary *)conf {
    self = [self init];
    if (self) {
        _configuration = conf;
        _buildingId = [conf[@"identifier"] longValue];
    }
    return self;
}

- (void)commonSetup {
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [CommonSettings commonNavigationBarBackgroundColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [CommonSettings commonNavigationBarForgroundColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[CommonSettings commonNavigationBarForgroundColor]};
    self.navigationController.toolbar.barTintColor = [CommonSettings commonToolbarColor];
    self.navigationController.toolbar.tintColor = [CommonSettings commonNavigationBarForgroundColor];
    self.view.backgroundColor = [CommonSettings commonViewForgroundColor];
    
    // MapView
    self.mapView = [[PWMapView alloc] initWithFrame:CGRectZero];
    self.mapView.delegate = self;
    self.mapView.isAccessibilityElement = NO;
    self.mapView.accessibilityLabel = @"";
    [self.view addSubview:_mapView];
    [self.mapView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.segmentBackground];
    [self.mapView autoPinToBottomLayoutGuideOfViewController:self withInset:0];
    [self.mapView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.mapView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
     [self configureRoutingInstructionsView];
    
    // Bar buttom items
    self.flexibleBarSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.navigationBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation"] style:UIBarButtonItemStylePlain target:self action:@selector(btnNavigation:)];
    self.navigationBarButton.accessibilityLabel = PWLocalizedString(@"GetDirectionsButton", @"Get Directions");
    self.navigationBarButton.accessibilityHint = PWLocalizedString(@"NavigationButtonHint", @"Double tap to select points to start a route");
    
    self.cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnCancelRoute:)];
    self.cancelBarButton.accessibilityHint = PWLocalizedString(@"CancelButtonHint", @"Double tap to cancel the current route");
    
    self.floorsBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"floor"] style:UIBarButtonItemStylePlain target:self action:@selector(btnChangeFloor:)];
    self.floorsBarButton.accessibilityLabel = PWLocalizedString(@"Floors", @"Floors");
    self.floorsBarButton.accessibilityHint = PWLocalizedString(@"FloorFilterButtonHint", @"Double tap to select floor filter");
    
    self.categoriesBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(btnChangeCategory:)];
    self.categoriesBarButton.accessibilityLabel = PWLocalizedString(@"Categories", @"Categories");
    self.categoriesBarButton.accessibilityHint = PWLocalizedString(@"CategoryFilterButtonHint", @"Double tap to select category filter");
    
    self.distanceBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"distance"] style:UIBarButtonItemStylePlain target:self action:@selector(btnChangeDistance:)];
    self.distanceBarButton.accessibilityLabel = PWLocalizedString(@"Distance", @"Distance");
    self.distanceBarButton.accessibilityHint = PWLocalizedString(@"DistanceFilterButtonHint", @"Double tap to select distance filter");
    
    self.trackingModeView = [[TrackingModeView alloc] initWithMapView:self.mapView];
    
    // Remove for external sample
    self.buildingsBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list"] style:UIBarButtonItemStylePlain target:self action:@selector(btnChangeBuilding:)];
    
    [self configureBottomToolbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnCancelRoute:) name:CancelCurrentRouteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyShowRoute:) name:PlotRouteNotification object:nil];
}

- (void)configureRoutingInstructionsView {
    self.routeInstruction = [[RouteInstructionsView alloc] init];
    self.routeInstruction.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.routeInstruction.delegate = self;
    [self.mapView addSubview:self.routeInstruction];
    
    [self.routeInstruction autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.segmentBackground];
    [self.routeInstruction autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.routeInstruction autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.routeInstruction autoSetDimension:ALDimensionHeight toSize:RouteInstructionHeight];
    
    [self shouldShowRouteInstructions:NO];
}

- (void)configureBottomToolbar {
    // Set map as selected segment
    [self.navigationItem setLeftBarButtonItem:_navigationBarButton];
    [self.navigationItem setRightBarButtonItem:nil];
    
    // Remove for external sample and uncomment next line
    [self setToolbarItems:@[self.buildingsBarButton, self.flexibleBarSpace, self.trackingModeView, self.flexibleBarSpace, self.categoriesBarButton, self.flexibleBarSpace, self.floorsBarButton] animated:YES];
    // [self setToolbarItems:@[self.trackingModeView, self.flexibleBarSpace, self.categoriesBarButton, self.flexibleBarSpace, self.floorsBarButton] animated:YES];
}

#pragma mark - Override

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isDirectorySegments) {
        [self.searchField setHidden:NO];
    }
    self.navigationController.toolbarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.searchField setHidden:YES];
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSegments];
    [self commonSetup];
    [self setupSearch];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
    self.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.loadingView.backgroundColor = [UIColor lightGrayColor];
    self.loadingView.alpha = 0.8;
    [self.loadingView startAnimating];
    
    if (self.building) {
        [self.mapView setBuilding:self.building];
        return;
    }
    
    // Remove for external sample
    [self showFirebaseBuildingSelection];
    
    // Uncomment for external sample
    //[self fetchBuilding];
    
    [self addCustomAnnotation];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Remove for external sample
- (void)showFirebaseBuildingSelection {
    __weak typeof(self) weakself = self;
    [[FBBuildingManager shared] showBuildingsViewController:self withSelectedBuildingCompletion:^{
        [weakself.navigationController.view addSubview:weakself.loadingView];
        
        FBBuilding *fbBuilding = [FBBuildingManager shared].currentBuilding;
        [PWCore setApplicationID:fbBuilding.appId accessKey:fbBuilding.accessKey signatureKey:fbBuilding.signatureKey encryptionKey:@""];
        [PWCore setEnvironment:fbBuilding.environment];
        weakself.buildingId = [[FBBuildingManager shared].currentBuilding.buildingId longValue];
        
        [PWBuilding buildingWithIdentifier:weakself.buildingId completion:^(PWBuilding *building, NSError *error) {
            if (building) {
                weakself.building = building;
                [weakself.mapView setBuilding:weakself.building];
                
                weakself.buildingFinishedLoading = YES;
                [weakself removeLoadingViewIfDone];
                dispatch_async(dispatch_get_main_queue(), ^{
                    PWManagedLocationManager *managedLocationManager = [[PWManagedLocationManager alloc] initWithBuildingId:weakself.buildingId];
                    
                    [weakself.mapView registerLocationManager:managedLocationManager];
                });
            }
        }];
    }];
}

- (void)fetchBuilding {
    __weak typeof(self) weakself = self;
    [self.navigationController.view addSubview:self.loadingView];
    [PWBuilding buildingWithIdentifier:self.buildingId completion:^(PWBuilding *building, NSError *error) {
        if (building) {
            weakself.building = building;
            [weakself.mapView setBuilding:weakself.building];
            
            weakself.buildingFinishedLoading = YES;
            [weakself removeLoadingViewIfDone];
            dispatch_async(dispatch_get_main_queue(), ^{
                PWManagedLocationManager *managedLocationManager = [[PWManagedLocationManager alloc] initWithBuildingId:weakself.buildingId];

                [weakself.mapView registerLocationManager:managedLocationManager];
            });
        }
    }];
}

#pragma mark - Public

- (void)setTitle:(NSString *)title {
    if (title) {
        [super setTitle:title];
        [self.searchField setHidden:YES];
    } else {
        [super setTitle:nil];
        [self.searchField setHidden:NO];
    }
}

- (void)resetMapView {
    self.mapView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchField.delegate = self;
    self.floorsBarButton.target = self;
    self.categoriesBarButton.target = self;
    self.distanceBarButton.target = self;
    self.mapView.hidden = NO;
    self.tableView.hidden = YES;
    
    self.buildingsBarButton.target = self;
    
    [self setTitle:nil];
    [self shrinkSearchField:YES showCancelButton:NO];
    [self setDirectorySegments];

    [self configureBottomToolbar];
}

#pragma mark - Actions

- (void)btnNavigation:(id)sender {
    self.routeController = self.routeController ?: [[RouteController alloc] initWithMapViewController:self];
    [self.routeController loadView];
}

- (void)btnChangeFloor:(id)sender {
    __weak typeof(self) weakself = self;
    UIAlertController *alertController = [CommonSettings buildActionSheetWithItems:self.building.floors displayProperty:@"name" selectedItem:self.mapView.currentFloor title:PWLocalizedString(@"SheetTitleForFloor", @"Change Floor") actionNameFormat:nil topAction:nil selectAction:^(id selection) {
        [weakself.mapView setFloor:selection];
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)btnChangeCategory:(id)sender {
    POITypeViewController *poiTypeVC = [[POITypeViewController alloc] init];
    poiTypeVC.delegate = self;
    poiTypeVC.selectedPoiType = self.filterPOIType;
    poiTypeVC.poiTypes = [self.building getAvailablePOITypes];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:poiTypeVC];
    navigationController.navigationBar.barTintColor = [CommonSettings commonNavigationBarBackgroundColor];
    navigationController.navigationBar.translucent = NO;
    [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)filterMapPOIByType:(PWPointOfInterestType *)type {
    __weak typeof(self) weakself = self;
    [self.mapView.currentFloor.pointsOfInterest enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PWPointOfInterest *poi = obj;
        MKAnnotationView *view = [weakself.mapView viewForPointOfInterest:poi];
        
        if (!type || poi.pointOfInterestType == type) {
            view.hidden = NO;
        } else {
            view.hidden = YES;
        }
    }];
}

- (void)btnChangeDistance:(id)sender {
    __weak typeof(self) weakself = self;
    UIAlertController *alertController = [CommonSettings buildActionSheetWithItems:filterDistance() displayProperty:nil selectedItem:self.filterRadius title:PWLocalizedString(@"SheetTitleForDistance", @"Change Distance") actionNameFormat:nil topAction:nil selectAction:^(id selection) {
        weakself.filterRadius = selection;
        [weakself search:nil];
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)btnCancelRoute:(id)sender {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self resetMapView];
    
    if (self.mapView.currentRoute) {
        [self.mapView cancelRouting];
    }
    
    [self.offRouteTimer invalidate];
    self.offRouteTimer = nil;

    if (self.routeInstruction) {
        [self shouldShowRouteInstructions:NO];
    }
    
    if (self.routingDirectionsTableView) {
        [self.routingDirectionsTableView removeFromSuperview];
        self.routingDirectionsTableView = nil;
    }
}

// Remove for external sample
- (void)btnChangeBuilding:(id)sender {
    [self showFirebaseBuildingSelection];
}

#pragma mark - POITypeViewControllerDelegate

- (void)didSelectPOIType:(PWPointOfInterestType *)poiType {
    self.filterPOIType = poiType;
    [self filterMapPOIByType:poiType];
}

#pragma mark - Loading

- (void)removeLoadingViewIfDone {
    if (self.buildingFinishedLoading && self.mapViewFinishedRendering && !self.directoryWasAutoSelected) {
        self.directoryWasAutoSelected = YES;
        if (UIAccessibilityIsVoiceOverRunning()) {
            [self selectSegmentFor:DirectorySegmentsDirectory];
        }
        
        // Set floor level 1 ans default floor
        if (self.mapView.currentFloor.level != 1) {
            __weak typeof(self) weakself = self;
            [self.mapView.building.floors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PWFloor *floor = obj;
                if (floor.level == 1) {
                    [weakself.mapView setFloor:floor];
                }
            }];
        }
        
        [self.loadingView stopAnimating];
        [self.loadingView removeFromSuperview];
    }
}

#pragma mark - PWMapView Delegate

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    self.mapViewFinishedRendering = YES;
    [self removeLoadingViewIfDone];
}

- (void)mapView:(PWMapView *)mapView didChangeFloor:(PWFloor *)currentFloor {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself filterMapPOIByType:weakself.filterPOIType];
    });
}

- (void)mapView:(PWMapView *)mapView didUpdateHeading:(CLHeading *)heading {
    [[NSNotificationCenter defaultCenter] postNotificationName:CurrentUserHeadingUpdatedNotification object:heading];
}

- (void)mapView:(PWMapView *)mapView locationManager:(id<PWLocationManager>)locationManager didUpdateIndoorUserLocation:(PWIndoorLocation *)userLocation {
    if (userLocation.floorID == NSNotFound) {
        return;
    }
    
    if (!self.zoomWasSetWhenLocationWasFound) {
        self.zoomWasSetWhenLocationWasFound = YES;
        PWFloor *currentUserFloor = [self.building floorForFloorID:userLocation.floorID];
        [self.mapView setFloor:currentUserFloor];
        [self.mapView setCenterCoordinate:userLocation.coordinate zoomLevel:30 animated:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CurrentUserLocationUpdatedNotification object:userLocation];
}

- (void)mapViewStartedSnappingLocationToRoute:(PWMapView *)mapView {
    [self.offRouteTimer invalidate];
    self.offRouteTimer = nil;
}

- (void)mapViewStoppedSnappingLocationToRoute:(PWMapView *)mapView {
    if (self.offRouteTimer == nil && !self.offeredToRecalculateRoute && self.mapView.currentRoute) {
        self.offRouteTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(userIsOffRoute) userInfo:nil repeats:NO];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Custom Annotation"];
    view.enabled = YES;
    view.canShowCallout = YES;
    return view;
}

- (void)mapView:(PWMapView *)mapView didChangeTrackingMode:(PWTrackingMode)mode {
    [self.trackingModeView updateButtonStateAnimated:YES];
}

#pragma mark - MapViewControllerDelegate

- (void)notifyShowRoute:(NSNotification*)notification {
    PWRoute *route = notification.object;
    if (route) {
        [self showRoute:route];
    }
}

- (void)showRoute:(PWRoute *)route {
    if ([self.mapView.currentRoute isEqual:route]) {
        return;
    }
    
    // Plot route
    self.mapView.delegate = self;
    [self.mapView navigateWithRoute:route];
    [self.mapView setHidden:NO];
    [self shouldShowRouteInstructions:YES];
    [self showRoutingInstructionsList];
    [self.routingDirectionsTableView setHidden:YES];
    
    // Turn on follow me mode
    if (self.mapView.userLocation) {
        self.mapView.trackingMode = PWTrackingModeFollowWithHeading;
    }
    self.offeredToRecalculateRoute = NO;
    self.userWasInformedOfReachingDestination = NO;
    
    // UI update
    [self setTitle:PWLocalizedString(@"RouteNavigationTitle", @"Direction")];
    [self.navigationItem setLeftBarButtonItem:_cancelBarButton];
    [self.navigationItem setRightBarButtonItem:nil];
    [self.tableView setHidden:YES];
    [self setRouteSegments];
    [self setToolbarItems:@[self.trackingModeView] animated:YES];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

#pragma mark - PWRouteInstructionViewDelegate

- (void)route:(PWRoute *) route didChangeRouteInstruction:(PWRouteInstruction *) instruction {
    [self.mapView setRouteManeuver:instruction];
}

#pragma mark - PWRouteStartViewDelegate

- (void)didSelectDetails:(PWRoute *)route {
    PreRoutingViewController *preRoutingViewController = [PreRoutingViewController new];
    preRoutingViewController.route = route;
    [self presentViewController:preRoutingViewController animated:YES completion:nil];
}

#pragma mark - Routing

- (void)showRoutingInstructionsList {
    self.routingDirectionsTableView = [[RoutingDirectionsTableView alloc] initWithRoute:self.mapView.currentRoute];
    [self.view addSubview:_routingDirectionsTableView];
    [self.routingDirectionsTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.segmentBackground];
    [self.routingDirectionsTableView autoPinToBottomLayoutGuideOfViewController:self withInset:0];
    [self.routingDirectionsTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.routingDirectionsTableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.mapView startUpdatingHeading];
}

- (void)shouldShowRouteInstructions:(BOOL)show {
    self.routeInstruction.hidden = !show;
    
    if (show) {
        self.routeInstruction.route = self.mapView.currentRoute;
    }
}

- (void)userIsOffRoute {
    if (self.mapView.currentRoute == nil || self.offeredToRecalculateRoute) {
        return;
    }
    
    // Mark it's calculating a new route
    self.offeredToRecalculateRoute = YES;
    
    // Start route
    __weak typeof(self) weakSelf = self;
    [PWRoute initRouteFrom:self.mapView.userLocation to:self.mapView.currentRoute.endPointOfInterest accessibility:YES completion:^(PWRoute *route, NSError *error) {
        if (error) {
            NSLog(@"There was a problem with recalculating the route.");
            return;
        }
        
        if (![weakSelf.mapView.currentRouteInstruction isEqualRouteInstruction:[route.routeInstructions firstObject]]) {
            [weakSelf btnCancelRoute:nil];
            [weakSelf showRoute:route];
            
            // Notify route changed only when the new route is different from current one
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = PWLocalizedString(@"OffRouteDetected", @"Recalculating route.");
            [hud hideAnimated:YES afterDelay:3];
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, hud);
        }
        
        weakSelf.offeredToRecalculateRoute = NO;
    }];
}

#pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.routingDirectionsTableView reloadData];
}

#pragma mark - Custom Annotation

- (void) addCustomAnnotation {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(30.359648, -97.742567);
    annotation.title = @"A Custom Annotation";
    annotation.subtitle = @"A Custom Annotation";
    [self.mapView addAnnotation:annotation];
}

@end
