//
//  PreRoutingViewController.m
//  PWMapKit
//
//  Created on 8/11/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import <PWMapKit/PWMapKit.h>

#import "PreRoutingViewController.h"
#import "CommonSettings.h"
#import "RouteSummaryTableViewCell.h"
#import "PreRouteInstructionTableViewCell.h"
#import "RouteLabelTableViewCell.h"
#import "MapPreviewTableViewCell.h"
#import "ShowAllStepsTableViewCell.h"

static CGFloat const StartNavigationContainerViewHeight = 80.0;

@interface PreRoutingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *startNavigationContainerView;
@property (nonatomic, assign) BOOL listViewIsSelected;
@property (nonatomic, strong) PWMapView *mapViewForPreview;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, assign) BOOL showAllSteps;

@end

@implementation PreRoutingViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.segmentedControl.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:nil];
    self.listViewIsSelected = YES;
    self.showAllSteps = !UIAccessibilityIsVoiceOverRunning();
    
    [self configureTableView];
    [self configureStartNavigationContainerView];
    [self configureNavigationBar];
}

#pragma mark - Configuration

- (void)configureNavigationBar {
    NSString *listString = PWLocalizedString(@"SegmentTitleList", @"List");
    NSString *mapString = PWLocalizedString(@"SegmentTitleMap", @"Map");
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[listString, mapString]];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl setWidth:80 forSegmentAtIndex:0];
    [self.segmentedControl setWidth:80 forSegmentAtIndex:1];
    
    [self.navigationController.navigationBar addSubview:self.segmentedControl];
    [self.segmentedControl autoCenterInSuperview];
}

- (void)configureTableView {
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, StartNavigationContainerViewHeight, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, StartNavigationContainerViewHeight, 0);
    [self.tableView registerClass:[RouteSummaryTableViewCell class] forCellReuseIdentifier:RouteSummaryTableViewCellReuseIdentifier];
    [self.tableView registerClass:[PreRouteInstructionTableViewCell class] forCellReuseIdentifier:PreRouteInstructionCellReuseIdentifier];
    [self.tableView registerClass:[RouteLabelTableViewCell class] forCellReuseIdentifier:RouteLabelTableViewCellReuseIdentifier];
    [self.tableView registerClass:[MapPreviewTableViewCell class] forCellReuseIdentifier:MapPreviewTableViewCellReuseIdentifier];
    [self.tableView registerClass:[ShowAllStepsTableViewCell class] forCellReuseIdentifier:ShowAllStepsCellReuseIdentifier];
    [self.view addSubview:self.tableView];
    
    [self.tableView autoPinEdgesToSuperviewEdges];
}

- (void)configureStartNavigationContainerView {
    self.startNavigationContainerView = [UIView new];
    self.startNavigationContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.startNavigationContainerView];
    
    [self.startNavigationContainerView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.startNavigationContainerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.startNavigationContainerView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.startNavigationContainerView autoSetDimension:ALDimensionHeight toSize:StartNavigationContainerViewHeight];
    
    UIButton *startNavigationButton = [UIButton new];
    startNavigationButton.backgroundColor = [CommonSettings commonButtonBackgroundColor];
    startNavigationButton.tintColor = [UIColor whiteColor];
    startNavigationButton.layer.cornerRadius = 25;
    startNavigationButton.clipsToBounds = YES;
    [startNavigationButton setTitle:PWLocalizedString(@"StartNavigationButtonTitle", @"START NAVIGATION") forState:UIControlStateNormal];
    startNavigationButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [startNavigationButton addTarget:self action:@selector(startNavigationButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.startNavigationContainerView addSubview:startNavigationButton];
    
    [startNavigationButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [startNavigationButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [startNavigationButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.startNavigationContainerView withMultiplier:0.6];
    [startNavigationButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.startNavigationContainerView withMultiplier:0.9];
}

#pragma mark - Table View DataSource and Delegate

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = UITableViewAutomaticDimension;
    if (!self.listViewIsSelected && indexPath.row == 1) {
        height = self.tableView.contentSize.height;
    }
    return height;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = self.route.routeInstructions.count + 2;
    if (!self.listViewIsSelected) {
        numberOfRows = 2;
    } else if (!self.showAllSteps) {
        return 2;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        RouteSummaryTableViewCell *routeSummaryTableViewCell = [tableView dequeueReusableCellWithIdentifier:RouteSummaryTableViewCellReuseIdentifier];
        [routeSummaryTableViewCell configureForRoute:self.route];
        
        cell = routeSummaryTableViewCell;
    } else {
        if (self.listViewIsSelected) {
            cell = [self cellForListViewAtIndexPath:indexPath tableView:tableView];
        } else {
            cell = [self cellForMapViewAtIndexPath:indexPath tableView:tableView];
        }
    }
    
    return cell;
}

- (UITableViewCell *)cellForListViewAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    UITableViewCell *cell = nil;
    if (indexPath.row == 1 && self.showAllSteps) {
        RouteLabelTableViewCell *routeLabelTableViewCell = [tableView dequeueReusableCellWithIdentifier:RouteLabelTableViewCellReuseIdentifier];
        [routeLabelTableViewCell configure];
        cell = routeLabelTableViewCell;
    } else if (self.showAllSteps) {
        PreRouteInstructionTableViewCell *preRouteInstructionTableViewCell = [tableView dequeueReusableCellWithIdentifier:PreRouteInstructionCellReuseIdentifier];
        
        PWRouteInstruction *routeInstruction = self.route.routeInstructions[indexPath.row - 2];
        [preRouteInstructionTableViewCell configureForRouteInstruction:routeInstruction];
        
        cell = preRouteInstructionTableViewCell;
    } else {
        ShowAllStepsTableViewCell *showAllStepsCell = [tableView dequeueReusableCellWithIdentifier:ShowAllStepsCellReuseIdentifier];
        
        [showAllStepsCell configureForShowAllStepsSelector:@selector(showAllStepsButtonTapped) showAllStepsTarget:self];
        
        cell = showAllStepsCell;
    }
    return cell;
}

- (UITableViewCell *)cellForMapViewAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    UITableViewCell *cell = nil;
    if (indexPath.row == 1) {
        if (self.mapViewForPreview == nil) {
            self.mapViewForPreview = [PWMapView new];
            [self.mapViewForPreview setBuilding:self.route.building];
        }
        MapPreviewTableViewCell *mapPreviewCell = [tableView dequeueReusableCellWithIdentifier:MapPreviewTableViewCellReuseIdentifier];
        [mapPreviewCell configureForRoute:self.route mapView:self.mapViewForPreview];
        cell = mapPreviewCell;
    }
    return cell;
}

#pragma mark - UI Actions

- (void)startNavigationButtonTapped {
    [self.segmentedControl setHidden:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    // Notify to plot the route
    [[NSNotificationCenter defaultCenter] postNotificationName:PlotRouteNotification object:self.route];
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentedControlChanged:(id)sender {
    UISegmentedControl *segmentedControl = sender;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self listSegmentSelected];
    } else {
        [self mapSegmentSelected];
    }
}

- (void)listSegmentSelected {
    self.listViewIsSelected = YES;
    [self.tableView reloadData];
}

- (void)mapSegmentSelected {
    self.listViewIsSelected = NO;
    [self.tableView reloadData];
}

- (void)showAllStepsButtonTapped {
    self.showAllSteps = YES;
    [self.tableView reloadData];
}

@end
