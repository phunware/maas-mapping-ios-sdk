//
//  SearchPOIViewController.m
//  MapScenariosObjC
//
//  Created on 3/8/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PWCore/PWCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "SearchPOIViewController.h"

static NSString * const poiCellReuseIdentifier = @"POICell";

@interface POITableViewCell: UITableViewCell

@property (nonatomic, strong) UIImageView *poiImageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)configureSubviews;

@end

@implementation POITableViewCell

- (void)configureSubviews {
    if (self.poiImageView != nil && self.titleLabel != nil) {
        return;
    }
    
    self.poiImageView = [UIImageView new];
    self.titleLabel = [UILabel new];
    
    self.poiImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.poiImageView];
    [self.poiImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10.0].active = YES;
    [self.poiImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.poiImageView.widthAnchor constraintEqualToConstant:32.0].active = YES;
    [self.poiImageView.heightAnchor constraintEqualToConstant:32.0].active = YES;
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.poiImageView.trailingAnchor constant:10.0].active = YES;
    [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:5.0].active = YES;
    [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:15.0].active = YES;
    [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-15.0].active = YES;
}

@end

@interface SearchPOIViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) NSString *applicationId;
@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *signatureKey;

@property (nonatomic, strong) PWMapView *mapView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sortedPointsOfInterest;
@property (nonatomic, strong) NSArray *filteredPointsOfInterest;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation SearchPOIViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _buildingIdentifier = 0; // Enter your building identifier here, found on the building's Edit page on Maas portal
        // Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
        _applicationId = @"";
        _accessKey = @"";
        _signatureKey = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Search for Point of Interest";
    
    if (self.applicationId.length > 0 && self.accessKey.length > 0 && self.signatureKey.length > 0) {
        [PWCore setApplicationID:self.applicationId accessKey:self.accessKey signatureKey:self.signatureKey];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.mapView = [PWMapView new];
    [self.view addSubview:self.mapView];
    [self configureMapViewConstraints];
    
    [PWBuilding buildingWithIdentifier:self.buildingIdentifier completion:^(PWBuilding *building, NSError *error) {
        __weak typeof(self) weakSelf = self;
        [weakSelf.mapView setBuilding:building animated:YES onCompletion:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf configureTableView];
            });
        }];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureMapViewConstraints {
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    [[self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
}

- (void)configureTableView {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    self.sortedPointsOfInterest = [self.mapView.building.pois sortedArrayUsingDescriptors:@[sortDescriptor]];
    self.filteredPointsOfInterest = [self.sortedPointsOfInterest copy];
    
    [self configureSearchController];
    self.tableView = [UITableView new];
    self.tableView.hidden = YES;
    [self.tableView registerClass:[POITableViewCell class] forCellReuseIdentifier:poiCellReuseIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self configureTableViewConstraints];
}

- (void)configureTableViewConstraints {
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.tableView.topAnchor constraintEqualToAnchor:self.navigationController.navigationBar.bottomAnchor] setActive:YES];
    [[self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    [[self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
}

- (void)configureSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search Points of Interest";
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    self.navigationItem.searchController = self.searchController;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredPointsOfInterest.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    POITableViewCell *poiCell = [tableView dequeueReusableCellWithIdentifier:poiCellReuseIdentifier forIndexPath:indexPath];
    [poiCell configureSubviews];
    
    PWPointOfInterest *pointOfInterest = self.filteredPointsOfInterest[indexPath.row];
    [poiCell.poiImageView sd_setImageWithURL:pointOfInterest.imageURL];
    poiCell.titleLabel.text = pointOfInterest.title;
    
    return poiCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchController.searchBar endEditing:YES];
    self.tableView.hidden = YES;
    PWPointOfInterest *pointOfInterest = self.filteredPointsOfInterest[indexPath.row];
    if (self.mapView.currentFloor.floorID != pointOfInterest.floorID) {
        PWFloor *newFloor = [self.mapView.building floorById:pointOfInterest.floorID];
        self.mapView.currentFloor = newFloor;
    }
    [self.mapView selectAnnotation:pointOfInterest animated:YES];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.searchBar.text == nil || searchController.searchBar.text.length == 0) {
        self.filteredPointsOfInterest = [self.sortedPointsOfInterest copy];
        [self.tableView reloadData];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchController.searchBar.text];
    self.filteredPointsOfInterest = [self.sortedPointsOfInterest filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.tableView.hidden = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.tableView.hidden = YES;
}

#pragma mark - Adjust for keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

@end
