//
//  POIDetailsViewController.m
//  PWMapKit
//
//  Created on 8/10/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PureLayout/PureLayout.h>
#import <QuartzCore/QuartzCore.h>

#import "POIDetailsViewController.h"
#import "CommonSettings.h"
#import "PreRoutingViewController.h"
#import "POIDetailsTableViewCell.h"
#import "POIDetailsSummaryCell.h"

static CGFloat const GetDirectionsContainerViewHeight = 80.0;

@interface POIDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *getDirectionsContainerView;

@end

@implementation POIDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:self.pointOfInterest.title];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationItem.title = PWLocalizedString(@"BackButtonTitle", @"Back");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeAndAddAllSubviews];
    [self configureTableView];
    [self configureGetDirectionsContainerView];
}

#pragma mark - Configuration

- (void)initializeAndAddAllSubviews {
    self.tableView = [UITableView new];
    self.getDirectionsContainerView = [UIView new];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.getDirectionsContainerView];
}

- (void)configureTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, GetDirectionsContainerViewHeight, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, GetDirectionsContainerViewHeight, 0);
    
    [self.tableView registerClass:[POIDetailsTableViewCell class] forCellReuseIdentifier:POIDetailsCellReuseIdentifier];
    [self.tableView registerClass:[POIDetailsSummaryCell class] forCellReuseIdentifier:POIDetailsSummaryCellReuseIdentifier];
    
    [self.tableView autoPinEdgesToSuperviewEdges];
}

- (void)configureGetDirectionsContainerView {
    self.getDirectionsContainerView.backgroundColor = [UIColor clearColor];
    
    [self.getDirectionsContainerView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.getDirectionsContainerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.getDirectionsContainerView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    if (!self.userLocation) {
        self.getDirectionsContainerView.hidden = YES;
        [self.getDirectionsContainerView autoSetDimension:ALDimensionHeight toSize:0];
    } else {
        self.getDirectionsContainerView.hidden = NO;
        [self.getDirectionsContainerView autoSetDimension:ALDimensionHeight toSize:GetDirectionsContainerViewHeight];
    }
    
    UIButton *getDirectionsButton = [UIButton new];
    getDirectionsButton.backgroundColor = [CommonSettings commonButtonBackgroundColor];
    getDirectionsButton.tintColor = [UIColor whiteColor];
    getDirectionsButton.layer.cornerRadius = 25;
    getDirectionsButton.clipsToBounds = YES;
    [getDirectionsButton setTitle:PWLocalizedString(@"GetDirectionsButtonTitle", @"GET DIRECTIONS") forState:UIControlStateNormal];
    getDirectionsButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [getDirectionsButton addTarget:self action:@selector(getDirectionsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.getDirectionsContainerView addSubview:getDirectionsButton];
    
    [getDirectionsButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [getDirectionsButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [getDirectionsButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.getDirectionsContainerView withMultiplier:0.6];
    [getDirectionsButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.getDirectionsContainerView withMultiplier:0.9];
}

#pragma mark - Table View DataSource and Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0: {
            POIDetailsTableViewCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:POIDetailsCellReuseIdentifier forIndexPath:indexPath];
            [detailsCell configureForKey:PWLocalizedString(@"BuildingColon", @"Building:") value:self.pointOfInterest.floor.building.name];
            cell = detailsCell;
        }
            break;
        case 1: {
            POIDetailsTableViewCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:POIDetailsCellReuseIdentifier forIndexPath:indexPath];
            [detailsCell configureForKey:PWLocalizedString(@"FloorColon", @"Floor:") value:self.pointOfInterest.floor.name];
            cell = detailsCell;
        }
            break;
        case 2: {
            POIDetailsTableViewCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:POIDetailsCellReuseIdentifier forIndexPath:indexPath];
            [detailsCell configureForKey:PWLocalizedString(@"TypeColon", @"Type:") value:self.pointOfInterest.pointOfInterestType.name];
            cell = detailsCell;
        }
            break;
        case 3: {
            POIDetailsTableViewCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:POIDetailsCellReuseIdentifier forIndexPath:indexPath];
            [detailsCell configureForKey:PWLocalizedString(@"CoordinateColon", @"Coordinate:") value:[NSString stringWithFormat:@"%.6f,%.6f", self.pointOfInterest.coordinate.latitude, self.pointOfInterest.coordinate.longitude]];
            cell = detailsCell;
        }
            break;
        case 4: {
            POIDetailsSummaryCell *summaryCell = [tableView dequeueReusableCellWithIdentifier:POIDetailsSummaryCellReuseIdentifier forIndexPath:indexPath];
            [summaryCell configureForSummary:self.pointOfInterest.summary];
            cell = summaryCell;
        }
            break;
        default: {
            POIDetailsTableViewCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:POIDetailsCellReuseIdentifier forIndexPath:indexPath];
            [detailsCell configureForKey:@"" value:@""];
            cell = detailsCell;
        }
            break;
    }
    
    return cell;
}

#pragma mark - UI Actions

- (void)getDirectionsButtonTapped {
    __weak typeof(self) weakSelf = self;
    [PWRoute initRouteFrom:self.userLocation to:self.pointOfInterest accessibility:YES completion:^(PWRoute *route, NSError *error) {
        PreRoutingViewController *preRoutingViewController = [PreRoutingViewController new];
        preRoutingViewController.route = route;
        [weakSelf showViewController:preRoutingViewController sender:weakSelf];
    }];
}

- (void)backButtonTapped {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
