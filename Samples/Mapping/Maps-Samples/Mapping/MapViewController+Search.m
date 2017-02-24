//
//  MapViewController+Search.m
//  PWMapKit
//
//  Created on 8/29/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PureLayout/PureLayout.h>

#import "MapViewController+Search.h"
#import "MapViewController+Segments.h"
#import "CommonSettings.h"

@implementation MapViewController (Search) 

#pragma mark - Public

- (void)setupSearch {
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [CommonSettings commonViewForgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    self.tableViewTopConstraint = [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.segmentBackground];
    [self.tableView autoPinToBottomLayoutGuideOfViewController:self withInset:0];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    // Search text
    self.searchField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.searchField.delegate = self;
    self.searchField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchField.textAlignment = NSTextAlignmentCenter;
    self.searchField.placeholder = PWLocalizedString(@"SearchFieldPlaceholder", @"Search for Point of Interest");
    self.searchField.returnKeyType = UIReturnKeySearch;
    self.searchField.clearButtonMode = UITextFieldViewModeAlways;
    self.searchField.tintColor = [CommonSettings commonNavigationBarBackgroundColor];
    [self.navigationController.navigationBar addSubview:self.searchField];
    [self.searchField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kStandardLineSpace];
    [self.searchField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kStandardLineSpace];
    [self.searchField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kStandardSpace];
    self.searchFieldFullConstraint = [self.searchField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kStandardSpace];
    self.searchFieldFullConstraint.active = NO;
    self.searchFieldShrinkWithCancelConstraint = [self.searchField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:80.f];
    self.searchFieldShrinkWithCancelConstraint.active = NO;
    self.searchFieldShrinkConstraint = [self.searchField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:50.f];
}

- (void)shrinkSearchField:(BOOL)shrink showCancelButton:(BOOL)showCancelButton {
    if (shrink) {
        self.searchFieldFullConstraint.active = NO;
        if (showCancelButton) {
            UIBarButtonItem *cancelSearchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSearch)];
            cancelSearchButton.accessibilityHint = PWLocalizedString(@"CancelButtonHint", @"Double tap to cancel the current route");
            self.navigationItem.leftBarButtonItem = cancelSearchButton;
            self.searchFieldShrinkConstraint.active = NO;
            self.searchFieldShrinkWithCancelConstraint.active = YES;
        } else {
            self.navigationItem.leftBarButtonItem = self.navigationBarButton;
            self.searchFieldShrinkWithCancelConstraint.active = NO;
            self.searchFieldShrinkConstraint.active = YES;
        }
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        self.searchFieldShrinkConstraint.active = NO;
        self.searchFieldShrinkWithCancelConstraint.active = NO;
        self.searchFieldFullConstraint.active = YES;
    }
}

- (NSArray *)search:(NSString *)keyword {
    NSMutableArray *pois = [NSMutableArray new];
    if (self.filterFloor) {
        [pois addObjectsFromArray:[self.filterFloor pointsOfInterestOfType:self.filterPOIType containing:keyword]];
    } else {
        for (PWFloor *floor in self.building.floors) {
            [pois addObjectsFromArray:[floor pointsOfInterestOfType:self.filterPOIType containing:keyword]];
        }
    }
    
    self.filteredPOIs = pois.copy;
    [self.tableView reloadData];
    
    return self.filteredPOIs;
}

- (void)resetSearch {
    [self.searchField resignFirstResponder];
    self.searchField.text = nil;
}

#pragma mark - Private

- (void)cancelSearch {
    [self.searchField resignFirstResponder];
    self.searchField.text = nil;
    self.tableView.hidden = YES;
    [self shrinkSearchField:YES showCancelButton:NO];
    [self hideSegments:NO];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.tableView.hidden = NO;
    [self shrinkSearchField:YES showCancelButton:YES];
    [self hideSegments:YES];
    [self search:nil];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length > 0) {
        [self search:[textField.text substringWithRange:NSMakeRange(0, range.location)]];
    } else {
        [self search:[textField.text stringByAppendingString:string]];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self search:nil];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredPOIs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"poiCellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"poiCellIdentifier"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
    }
    
    PWPointOfInterest *poi = [self.filteredPOIs objectAtIndex:indexPath.row];
    cell.imageView.image = poi.image;
    cell.textLabel.text = poi.title;
    cell.detailTextLabel.text = poi.floor.name;
    
    CGSize itemSize = CGSizeMake(kStandardIconSize, kStandardIconSize);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cancelSearch];
    [self.mapView navigateToPointOfInterest:self.filteredPOIs[indexPath.row]];
}

@end
