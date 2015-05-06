//
//  SearchViewController.m
//  POI Management
//
//  Created by Illya Busigin on 5/6/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "SearchViewController.h"
#import "POITableViewCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <PWMapKit/PWMapKit.h>

@interface SearchViewController () <UISearchDisplayDelegate>

@property NSArray *buildingAnnotations;
@property NSArray *searchResults;

@end

@implementation SearchViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[POITableViewCell class] forCellReuseIdentifier:@"POITableViewCell"];
    
    __weak typeof(self) weakSelf = self;
    [[PWBuildingManager sharedManager] getBuildingAnnotationsWithBuildingID:17457 completion:^(NSArray *annotations, NSError *error) {
        if (!error) {
            weakSelf.buildingAnnotations = annotations;
            [weakSelf.tableView reloadData];
        }
    }];
}


#pragma mark - Actions

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchDisplayController.isActive) {
        return self.searchResults.count;
    } else {
        return self.buildingAnnotations.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    POITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"POITableViewCell"];
    
    PWBuildingAnnotation *buildingAnnotation = nil;
    
    if (self.searchDisplayController.isActive) {
        buildingAnnotation = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        buildingAnnotation = [self.buildingAnnotations objectAtIndex:indexPath.row];
    }
    
    cell.annotationTitleLabel.text = buildingAnnotation.title;
    cell.visibilitySwitch.hidden = YES;
 
    [cell.annotationImageView setImageWithURL:buildingAnnotation.imageURL placeholderImage:nil];
    
    return cell;
}

#pragma mark - UISearchDisplayDelegate

// register a cell reuse identifier for the search results table view
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView registerClass:[POITableViewCell class] forCellReuseIdentifier:@"POITableViewCell"];
}

// perform the search
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchString];
    NSArray *searchResults = [self.buildingAnnotations filteredArrayUsingPredicate:predicate];
    
    [self setSearchResults:searchResults];
    
    return YES;
}

@end
