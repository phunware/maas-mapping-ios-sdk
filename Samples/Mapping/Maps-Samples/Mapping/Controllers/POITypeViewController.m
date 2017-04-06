//
//  POICategoryViewController.m
//  Maps-Samples
//
//  Created by Chesley Stephens on 4/5/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>

#import "POITypeViewController.h"
#import "CommonSettings.h"

NSString *const POITypeCellIdentifier = @"POITypeCellIdentifier";

@interface POITypeViewController()

@end

@implementation POITypeViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = PWLocalizedString(@"POI Types", @"POI Types");
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:POITypeCellIdentifier];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close:)];
}

- (void)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger numberOfRowsInSection = self.poiTypes.count + 1;
    
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:POITypeCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = PWLocalizedString(@"All Categories", @"All Categories");
        if (self.selectedPoiType == nil) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        NSInteger adjustedRow = [self adjustedRowForPOITypeIndex:indexPath];
        PWPointOfInterestType *poiType = self.poiTypes[adjustedRow];
        cell.textLabel.text = poiType.name;
        
        if (poiType.identifier == self.selectedPoiType.identifier) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (NSInteger)adjustedRowForPOITypeIndex:(NSIndexPath *)indexPath {
    NSInteger adjustedRow = indexPath.row - 1;
    return adjustedRow;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(didSelectPOIType:)]) {
        if (indexPath.row == 0) {
            [self.delegate didSelectPOIType:nil];
        } else {
            NSInteger adjustedRow = [self adjustedRowForPOITypeIndex:indexPath];
            PWPointOfInterestType *poiType = self.poiTypes[adjustedRow];
            [self.delegate didSelectPOIType:poiType];
        }
    }
    
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
