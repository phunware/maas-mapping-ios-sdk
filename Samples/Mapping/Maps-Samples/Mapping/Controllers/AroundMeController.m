//
//  AroundMeController.m
//  PWMapKit
//
//  Created on 8/17/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWLocation/PWLocation.h>
#import <PureLayout/PureLayout.h>

#import "AroundMeController.h"
#import "CommonSettings.h"

@interface AroundMeController()

@property (nonatomic, strong) PWIndoorLocation *lastLocation;

@end

@implementation AroundMeController

#pragma mark - Public

- (void)search:(NSString *)keyword {
    NSMutableArray *pois = [NSMutableArray new];
    CLLocation *userLocation = nil;
    if (_lastLocation) {
        userLocation = [[CLLocation alloc] initWithLatitude:_lastLocation.coordinate.latitude longitude:_lastLocation.coordinate.longitude];
        for (PWFloor *floor in self.building.floors) {
            if (floor.floorID == _lastLocation.floorID) {
                for (PWPointOfInterest *poi in [floor pointsOfInterestOfType:self.filterPOIType containing:keyword]) {
                    CLLocation *poiLocation = [[CLLocation alloc] initWithLatitude:poi.coordinate.latitude longitude:poi.coordinate.longitude];
                    CLLocationDistance distanceInMeter = [userLocation distanceFromLocation:poiLocation];
                    double distanceInFeet = [CommonSettings distanceInFeetFromDistanceInMeters:distanceInMeter];
                    
                    if (distanceInFeet < [self.filterRadius doubleValue]) {
                        [pois addObject:poi];
                    }
                }
            }
        }
    }
    
    if (pois.count > 0) {
        self.filteredPOIs = [pois sortedArrayUsingComparator: ^NSComparisonResult(PWPointOfInterest *p1, PWPointOfInterest *p2) {
            NSNumber *dist1 = @([[[CLLocation alloc] initWithLatitude:p1.coordinate.latitude longitude:p1.coordinate.longitude] distanceFromLocation:userLocation]);
            NSNumber *dist2 = @([[[CLLocation alloc] initWithLatitude:p2.coordinate.latitude longitude:p2.coordinate.longitude] distanceFromLocation:userLocation]);
            return [dist1 compare:dist2];
        }];
    } else {
        self.filteredPOIs = nil;
    }
    
    [self.tableView reloadData];
}

- (void)adjustViews {
    [super adjustViews];
    [self.mapViewController setToolbarItems:@[self.categoriesBarButton, self.flexibleBarSpace, self.distanceBarButton] animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredPOIs.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [CommonSettings commonViewForgroundColor];
    UILabel *first = [[UILabel alloc] initWithFrame:CGRectZero];
    first.font = [UIFont boldSystemFontOfSize:20.0];
    first.textColor = [UIColor darkGrayColor];
    first.numberOfLines = 2;
    first.text = PWLocalizedString(@"InfoCurrentAtTitle", @"Currently At:");
    first.backgroundColor = [CommonSettings commonViewForgroundColor];
    [headerView addSubview:first];
    [first autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kStandardLineSpace];
    [first autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kStandardSpace];
    [first autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    if (!_lastLocation) {
        first.text = PWLocalizedString(@"InfoForCurrentLocationUnavailable", @"One second, we are having a hard time finding your position.");
        return headerView;
    } else if (self.filteredPOIs.count == 0) {
        first.text = [NSString stringWithFormat:PWLocalizedString(@"InfoForNoAroundPOIFound", @"Sorry, we couldn’t find any matching point of interest within %@ feet of you."), self.filterRadius];
        return headerView;
    }
    
    PWPointOfInterest *nearestPOI = self.filteredPOIs.firstObject;
    UILabel *second = [[UILabel alloc] initWithFrame:CGRectZero];
    second.font = [UIFont systemFontOfSize:17.0];
    second.textColor = [UIColor darkGrayColor];
    second.text = [NSString stringWithFormat:@"%@ %@", nearestPOI.title, nearestPOI.floor.name];
    second.backgroundColor = [CommonSettings commonViewForgroundColor];
    [headerView addSubview:second];
    [second autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:first withOffset:kStandardLineSpace];
    [second autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kStandardSpace];
    [second autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    UIView *thirdBg = [[UIView alloc] initWithFrame:CGRectZero];
    thirdBg.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:thirdBg];
    [thirdBg autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:second withOffset:kStandardLineSpace];
    [thirdBg autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [thirdBg autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [thirdBg autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    UILabel *third = [[UILabel alloc] initWithFrame:CGRectZero];
    third.font = [UIFont boldSystemFontOfSize:17.0];
    third.textColor = [UIColor darkGrayColor];
    third.text = [NSString stringWithFormat:PWLocalizedString(@"InfoForCurrentFilterDistance", @"Following are within %@ feet:"), @(floor([self.filterRadius doubleValue]))];
    [thirdBg addSubview:third];
    [third autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, kStandardSpace, 0, 0)];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 90.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PWPointOfInterest *pointOfInterest = self.filteredPOIs[indexPath.row];
    return [self cellForPointOfInterest:pointOfInterest tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PWPointOfInterest *pointOfInterest = [self.filteredPOIs objectAtIndex:indexPath.row];
    [self selectPointOfInterest:pointOfInterest];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - PWMapViewDelegate

- (void)mapView:(PWMapView *)mapView locationManager:(id<PWLocationManager>)locationManager didUpdateIndoorUserLocation:(PWIndoorLocation *)userLocation {
    if (!userLocation) {
        return;
    }
    
    if (!_lastLocation || ABS([_lastLocation.timestamp timeIntervalSinceNow]) > kViewRefreshInterval) {
        _lastLocation = userLocation;
        [self search:self.searchField.text];
    }
}

@end
