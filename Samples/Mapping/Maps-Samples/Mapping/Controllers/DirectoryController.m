//
//  DirectoryController.m
//  PWMapKit
//
//  Created on 8/17/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "DirectoryController.h"
#import "MapViewController+Private.h"
#import "PWBuilding+Helper.h"
#import "POIDetailsViewController.h"
#import "CommonSettings.h"

@interface DirectoryController()

@end

@implementation DirectoryController

#pragma mark - Initialization

- (instancetype)initWithMapViewController:(MapViewController *)viewController {
    self = [super init];
    if (self) {
        _building = viewController.building;
        _mapView = viewController.mapView;
        _tableView = viewController.tableView;
        _searchField = viewController.searchField;
        _flexibleBarSpace = viewController.flexibleBarSpace;
        _navigationBarButton = viewController.navigationBarButton;
        _floorsBarButton = viewController.floorsBarButton;
        _categoriesBarButton = viewController.categoriesBarButton;
        _distanceBarButton = viewController.distanceBarButton;
        
        _mapViewController = viewController;
        
        _filterRadius = kDefaultSearchRadius;
        _filterFloor = nil;
        _filterPOIType = nil;
    }
    
    return self;
}

#pragma mark - Public

- (void)loadView {
    [self adjustViews];
    [self search:nil];
}

- (void)adjustViews {
    _tableView.hidden = NO;
    _mapView.hidden = YES;
    
    _mapView.delegate = self;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _searchField.delegate = self;
    
    _floorsBarButton.target = self;
    _categoriesBarButton.target = self;
    _distanceBarButton.target = self;
    
    [_mapViewController setToolbarItems:@[_floorsBarButton, _flexibleBarSpace, _categoriesBarButton] animated:YES];
}

- (void)search:(NSString *)keyword {
    NSMutableArray *pois = [NSMutableArray new];
    for (PWFloor *floor in _building.floors) {
        if (_filterFloor) {
            if (floor.level == _filterFloor.level) {
                [pois addObjectsFromArray:[floor pointsOfInterestOfType:_filterPOIType containing:keyword]];
            }
        } else {
            [pois addObjectsFromArray:[floor pointsOfInterestOfType:_filterPOIType containing:keyword]];
        }
    }
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    _filteredPOIs = [pois sortedArrayUsingDescriptors:@[nameSortDescriptor]];
    [self buildSectionedPOIs];
    [_tableView reloadData];
}

- (UITableViewCell *)cellForPointOfInterest:(PWPointOfInterest *)pointOfInterest tableView:(UITableView *)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"poiCellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"poiCellIdentifier"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
    }
    
    cell.imageView.image = pointOfInterest.image;
    cell.textLabel.text = pointOfInterest.title;
    cell.detailTextLabel.text = pointOfInterest.floor.name;
    
    CGSize itemSize = CGSizeMake(kStandardIconSize, kStandardIconSize);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

- (void)selectPointOfInterest:(PWPointOfInterest *)pointOfInterest {
    [self.searchField resignFirstResponder];
    POIDetailsViewController *poiDetailsViewController = [[POIDetailsViewController alloc] init];
    poiDetailsViewController.pointOfInterest = pointOfInterest;
    poiDetailsViewController.userLocation = self.mapView.userLocation;
    [self.mapViewController.navigationController pushViewController:poiDetailsViewController animated:YES];
}

- (void)buildSectionedPOIs {
    NSMutableArray *sectionedPOIs = [NSMutableArray new];
    NSMutableArray *currentSection = [NSMutableArray new];
    for (PWPointOfInterest *pointOfInterest in self.filteredPOIs) {
        if (currentSection.count > 0) {
            PWPointOfInterest *currentSectionPointOfInterest = [currentSection firstObject];
            NSString *pointOfInterestFirstCharacter = pointOfInterest.title.length > 0 ? [pointOfInterest.title substringToIndex:1] : @"";
            NSString *currentSectionPointOfInterestFirstCharacter = currentSectionPointOfInterest.title.length > 0 ? [currentSectionPointOfInterest.title substringToIndex:1] : @"";
            
            if ([pointOfInterestFirstCharacter caseInsensitiveCompare:currentSectionPointOfInterestFirstCharacter] != NSOrderedSame) {
                [sectionedPOIs addObject:currentSection];
                currentSection = [NSMutableArray new];
            }
        }
        [currentSection addObject:pointOfInterest];
    }
    [sectionedPOIs addObject:currentSection];
    self.sectionedPOIs = sectionedPOIs;
}

#pragma mark - Actions

- (IBAction)btnChangeFloor:(id)sender {
    __weak typeof(self) weakself = self;
    UIAlertController *alertController = [CommonSettings buildActionSheetWithItems:_building.floors displayProperty:@"name" selectedItem:_filterFloor title:PWLocalizedString(@"SheetTitleForFloor", @"Change Floor") actionNameFormat:nil topAction:PWLocalizedString(@"SheetActionNameAllForFloor", @"All Floors") selectAction:^(id selection) {
        weakself.filterFloor = selection;
        [weakself search:nil];
    }];
    [_mapViewController presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)btnChangeCategory:(id)sender {
    __weak typeof(self) weakself = self;
    UIAlertController *alertController = [CommonSettings buildActionSheetWithItems:[_building getAvailablePOITypes] displayProperty:@"name" selectedItem:_filterPOIType title:PWLocalizedString(@"SheetTitleForCategory", @"Change Category") actionNameFormat:nil topAction:PWLocalizedString(@"SheetActionNameAllForCategory", @"All Categories") selectAction:^(id selection) {
        weakself.filterPOIType = selection;
        [weakself search:nil];
    }];
    [_mapViewController presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)btnChangeDistance:(id)sender {
    __weak typeof(self) weakself = self;
    UIAlertController *alertController = [CommonSettings buildActionSheetWithItems:filterDistance() displayProperty:nil selectedItem:_filterRadius title:PWLocalizedString(@"SheetTitleForDistance", @"Change Distance") actionNameFormat:PWLocalizedString(@"SheetActionFormatForDistance", @"%@ feet") topAction:nil selectAction:^(id selection) {
        weakself.filterRadius = selection;
        [weakself search:nil];
    }];
    [_mapViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - TextField Delegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
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

- (BOOL) textFieldShouldClear:(UITextField *)textField {
    [self search:nil];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionedPOIs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *pointsOfInterestForSection = self.sectionedPOIs[section];
    return pointsOfInterestForSection.count;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *indexTitles = [NSMutableArray new];
    for (NSArray *pointsOfInterestForSection in self.sectionedPOIs) {
        if (pointsOfInterestForSection.count < 1) {
            continue;
        }
        PWPointOfInterest *pointOfInterest = [pointsOfInterestForSection firstObject];
        NSString *firstCharacterOfName = [pointOfInterest.title substringToIndex:1];
        [indexTitles addObject:[firstCharacterOfName uppercaseString]];
    }
    return indexTitles;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *pointsOfInterestForSection = self.sectionedPOIs[indexPath.section];
    PWPointOfInterest *pointOfInterest = [pointsOfInterestForSection objectAtIndex:indexPath.row];
    
    return [self cellForPointOfInterest:pointOfInterest tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *pointsOfInterestForSection = self.sectionedPOIs[indexPath.section];
    PWPointOfInterest *pointOfInterest = [pointsOfInterestForSection objectAtIndex:indexPath.row];
    [self selectPointOfInterest:pointOfInterest];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
