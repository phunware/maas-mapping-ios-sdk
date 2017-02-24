//
//  RouteController.m
//  PWMapKit
//
//  Created on 8/18/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import <QuartzCore/QuartzCore.h>

#import "MapViewController+Segments.h"
#import "MapViewController+Private.h"

#import "RouteController.h"
#import "CommonSettings.h"

#define kFontSize 12.0

@interface RouteController()

@property (nonatomic, strong) NSString *droppedPinText;
@property (nonatomic, strong) NSString *currentLocationText;

@end

@implementation RouteController

#pragma mark - Public

- (void)adjustViews {
    [super adjustViews];
    self.droppedPinText = PWLocalizedString(@"DroppedPin", @"Dropped Pin");
    self.currentLocationText = PWLocalizedString(@"CurrentLocation", @"Current Location");
    self.filterFloor = nil;
    self.filterPOIType = nil;
    
    _cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:PWLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(btnCancel:)];
    
    [self.mapViewController setTitle:PWLocalizedString(@"RouteNavigationTitle", @"Direction")];
    [self.mapViewController.navigationItem setLeftBarButtonItem:_cancelBarButton];
    [self.mapViewController.navigationItem setRightBarButtonItem:nil];
    [self.mapViewController hideSegments:YES];
    [self.mapViewController setToolbarItems:@[self.floorsBarButton, self.flexibleBarSpace, self.categoriesBarButton] animated:YES];
    [self showRouteHeaderView];
    [self.startField becomeFirstResponder];
}

- (void)search:(NSString*)keyword {
    NSMutableArray *pois = [NSMutableArray new];
    
    for (PWFloor *floor in self.building.floors) {
        if (!self.filterFloor || self.filterFloor.level == floor.level) {
            [pois addObjectsFromArray:[floor pointsOfInterestOfType:self.filterPOIType containing:keyword]];
        }
    }
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    self.filteredPOIs = [pois sortedArrayUsingDescriptors:@[nameSortDescriptor]];
    [self buildSectionedPOIs];
    [self.tableView reloadData];
}

#pragma mark - Private

- (void)preRouteCheck {
    if ([self.startField.text isEqualToString:self.endField.text] && self.startPOI.identifier == self.endPOI.identifier) {
        if (self.startField.isEditing) {
            self.startField.text = nil;
            self.startPOI = nil;
        } else if (self.endField.isEditing) {
            self.endField.text = nil;
            self.endPOI = nil;
        }
    }
    
    if (self.startField.text.length > 0 && self.endField.text.length > 0) {
        [self setRouteButtonActive:YES];
    } else {
        [self setRouteButtonActive:NO];
    }
}

- (void)showRouteHeaderView {
    if (self.mapViewController.routeHeaderView) {
        self.mapViewController.routeHeaderView.hidden = NO;
        self.startField.text = @"";
        self.endField.text = @"";
        [self setRouteButtonActive:NO];
    } else {
        self.mapViewController.routeHeaderView = [self headerView];
        [self.mapViewController.view addSubview:self.mapViewController.routeHeaderView];
        [self.mapViewController.routeHeaderView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.mapViewController.routeHeaderView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.mapViewController.routeHeaderView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    }
    // Pin top of tableView to routeHeader instead of segmentsBackground
    [self.mapViewController.tableViewTopConstraint autoRemove];
    self.mapViewController.tableViewTopConstraint = [self.mapViewController.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mapViewController.routeHeaderView];
}

- (void)hideRouteHeaderView {
    [self.mapViewController.tableViewTopConstraint autoRemove];
    self.mapViewController.tableViewTopConstraint = [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mapViewController.segmentBackground];
    self.mapViewController.routeHeaderView.hidden = YES;
}

- (UIView *)headerView {
    UIView *routeSearchView = [[UIView alloc] initWithFrame:CGRectZero];
    routeSearchView.backgroundColor = [CommonSettings commonViewForgroundColor];
    
    UIButton *swapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    swapButton.accessibilityHint = PWLocalizedString(@"RouteReverseButtonOffHint", @"Double tap to reverse start point and end point");
    [swapButton setImage:[UIImage imageNamed:@"reverse"] forState:UIControlStateNormal];
    [swapButton addTarget:self action:@selector(btnSwap:) forControlEvents:UIControlEventTouchUpInside];
    [routeSearchView addSubview:swapButton];
    [swapButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kStandardIconSize];
    [swapButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kStandardSpace];
    [swapButton autoSetDimension:ALDimensionWidth toSize:kStandardIconSize];
    
    _accessibilityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _accessibilityButton.accessibilityHint = PWLocalizedString(@"RouteAccessibilityButtonOffHint", @"Wheelchair accessible route, Double tap to enable");
    _accessibilityButton.alpha = 0.2f;
    [_accessibilityButton setImage:[UIImage imageNamed:@"accessibility"] forState:UIControlStateNormal];
    [_accessibilityButton addTarget:self action:@selector(btnAccessibility:) forControlEvents:UIControlEventTouchUpInside];
    [routeSearchView addSubview:_accessibilityButton];
    [_accessibilityButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kStandardIconSize];
    [_accessibilityButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kStandardSpace];
    [_accessibilityButton autoSetDimension:ALDimensionWidth toSize:kStandardIconSize];
    
    _startField = [[UITextField alloc] initWithFrame:CGRectZero];
    _startField.borderStyle = UITextBorderStyleRoundedRect;
    _startField.font = [UIFont systemFontOfSize:kFontSize];
    _startField.delegate = self;
    _startField.placeholder = PWLocalizedString(@"RouteStartSearchFieldPlaceholder", @"Search for start Point of Interest");
    _startField.autocorrectionType = UITextAutocorrectionTypeNo;
    _startField.returnKeyType = UIReturnKeyDone;
    _startField.clearButtonMode = UITextFieldViewModeAlways;
    _startField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UILabel *startLabel = [[UILabel alloc] initForAutoLayout];
    startLabel.text = PWLocalizedString(@"RouteStartSearchFieldLeftLabel", @" Start:");
    startLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
    startLabel.textColor = [UIColor lightGrayColor];
    startLabel.isAccessibilityElement = NO;
    _startField.leftViewMode = UITextFieldViewModeAlways;
    _startField.leftView = startLabel;
    [routeSearchView addSubview:_startField];
    [_startField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(kStandardIconSize + 2*kStandardSpace)];
    [_startField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:(kStandardIconSize + 2*kStandardSpace)];
    [_startField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kStandardSpace];
    
    _endField = [[UITextField alloc] initWithFrame:CGRectZero];
    _endField.borderStyle = UITextBorderStyleRoundedRect;
    _endField.font = [UIFont systemFontOfSize:kFontSize];
    _endField.delegate = self;
    _endField.placeholder = PWLocalizedString(@"RouteEndSearchFieldPlaceholder", @"Search for end Point of Interest");
    _endField.autocorrectionType = UITextAutocorrectionTypeNo;
    _endField.returnKeyType = UIReturnKeyDone;
    _endField.clearButtonMode = UITextFieldViewModeAlways;
    _endField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UILabel *endLabel = [[UILabel alloc] initForAutoLayout];
    endLabel.text = PWLocalizedString(@"RouteEndSearchFieldLeftLabel", @" End:");
    endLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
    endLabel.textColor = [UIColor lightGrayColor];
    endLabel.isAccessibilityElement = NO;
    _endField.leftViewMode = UITextFieldViewModeAlways;
    _endField.leftView = endLabel;
    [routeSearchView addSubview:_endField];
    [_endField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(kStandardIconSize + 2*kStandardSpace)];
    [_endField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:(kStandardIconSize + 2*kStandardSpace)];
    [_endField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_startField withOffset:kStandardSpace];
    
    [self buildRouteButton];
    [routeSearchView addSubview:self.routeButton];
    [self.routeButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(kStandardIconSize + 2*kStandardSpace)];
    [self.routeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:(kStandardIconSize + 2*kStandardSpace)];
    [self.routeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.endField withOffset:kStandardSpace];
    [self.routeButton autoSetDimension:ALDimensionHeight toSize:35];
    
    UIButton *droppedPinButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [droppedPinButton setTitle:PWLocalizedString(@"RouteDroppedPinButtonTitle", @"Dropped Pin") forState:UIControlStateNormal];
    [droppedPinButton addTarget:self action:@selector(btnDroppedPinButton:) forControlEvents:UIControlEventTouchUpInside];
    droppedPinButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [routeSearchView addSubview:droppedPinButton];
    [droppedPinButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(kStandardIconSize + 2*kStandardSpace)];
    [droppedPinButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.routeButton withOffset:kStandardSpace];
    [droppedPinButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kStandardSpace];
    if (!self.mapView.customLocation) {
        droppedPinButton.enabled = false;
    }
    
    UIButton *currentLocationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [currentLocationButton setTitle:PWLocalizedString(@"RouteCurrentLocationButtonTitle", @"Current Location") forState:UIControlStateNormal];
    [currentLocationButton addTarget:self action:@selector(btnCurrentLocationButton:) forControlEvents:UIControlEventTouchUpInside];
    currentLocationButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [routeSearchView addSubview:currentLocationButton];
    [currentLocationButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:(kStandardIconSize + 2*kStandardSpace)];
    [currentLocationButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.routeButton withOffset:kStandardSpace];
    [currentLocationButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:droppedPinButton withOffset:kStandardSpace];
    [currentLocationButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kStandardSpace];
    if (!self.mapView.userLocation) {
        currentLocationButton.enabled = false;
    }
    
    routeSearchView.accessibilityElements = @[self.startField, swapButton, self.endField, self.accessibilityButton, self.routeButton, droppedPinButton, currentLocationButton];
    
    return routeSearchView;
}

- (void)buildRouteButton {
    self.routeButton = [[UIButton alloc] initForAutoLayout];
    [self.routeButton addTarget:self action:@selector(btnRoute:) forControlEvents:UIControlEventTouchUpInside];
    [self.routeButton setTitle:PWLocalizedString(@"StartRouteButton", @"Route") forState:UIControlStateNormal];
    [self.routeButton setTitleColor:[CommonSettings commonToolbarColor] forState:UIControlStateNormal];
    [self.routeButton.layer setBorderColor:[self.routeButton.titleLabel.textColor CGColor]];
    [self.routeButton.layer setBorderWidth:1];
    self.routeButton.layer.cornerRadius = 7;
    self.routeButton.clipsToBounds = YES;
    self.routeButton.backgroundColor = [UIColor whiteColor];
    self.routeButton.userInteractionEnabled = NO;
    self.routeButton.accessibilityHint = PWLocalizedString(@"StartRouteButtonHint", @"Double tap to start route");
}

- (void)setRouteButtonActive:(BOOL)active {
    if (active) {
        [self.routeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.routeButton.backgroundColor = [CommonSettings commonToolbarColor];
        self.routeButton.userInteractionEnabled = YES;
    } else {
        [self.routeButton setTitleColor:[CommonSettings commonToolbarColor] forState:UIControlStateNormal];
        self.routeButton.backgroundColor = [UIColor whiteColor];
        self.routeButton.userInteractionEnabled = NO;
    }
}

#pragma mark - Actions

- (IBAction)btnCancel:(id)sender {
    [self hideRouteHeaderView];
    [self.mapViewController btnCancelRoute:sender];
    
    if(_startField.isEditing) {
        [_startField resignFirstResponder];
    } else if(_endField.isEditing) {
        [_startField resignFirstResponder];
    }
}

- (IBAction)btnSwap:(id)sender {
    self.startField.text = self.endPOI.title;
    self.endField.text = self.startPOI.title;
    
    PWPointOfInterest *startPOICopy = self.startPOI;
    self.startPOI = self.endPOI;
    self.endPOI = startPOICopy;
}

- (IBAction)btnAccessibility:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    if (senderButton.alpha == 1.0f) {
        _accessibilityButton.accessibilityHint = PWLocalizedString(@"RouteAccessibilityButtonOffHint", @"Wheelchair accessible route, Double tap to enable");
        _accessibilityButton.selected = NO;
        _accessibilityButton.alpha = 0.2f;
    } else {
        _accessibilityButton.accessibilityHint = PWLocalizedString(@"RouteAccessibilityButtonOnHint", @"Wheelchair accessible route, Double tap to disable");
        _accessibilityButton.selected = YES;
        _accessibilityButton.alpha = 1.0f;
    }
}

- (IBAction)btnDroppedPinButton:(id)sender {
    if (self.endField.isEditing) {
        self.endField.text = self.droppedPinText;
        [self.startField becomeFirstResponder];
    } else {
        self.startField.text = self.droppedPinText;
        [self.endField becomeFirstResponder];
    }
    
    [self preRouteCheck];
}

- (IBAction)btnCurrentLocationButton:(id)sender {
    if (self.endField.isEditing) {
        self.endField.text = self.currentLocationText;
        [self.startField becomeFirstResponder];
    } else {
        self.startField.text = self.currentLocationText;
        [self.endField becomeFirstResponder];
    }
    
    [self preRouteCheck];
}

- (IBAction)btnRoute:(id)sender {
    if (self.startField.isEditing) {
        [self.startField resignFirstResponder];
    } else if (self.endField.isEditing) {
        [self.endField resignFirstResponder];
    }
    
    BOOL accessibility = _accessibilityButton.selected;
    PWPointOfInterest *startPoint = self.startPOI;
    if (!startPoint) {
        if ([self.startField.text isEqualToString:self.droppedPinText]) {
            startPoint = self.mapViewController.mapView.customLocation;
        } else if ([self.startField.text isEqualToString:self.currentLocationText]) {
            startPoint = self.mapViewController.mapView.userLocation;
        }
    }
    PWPointOfInterest *endPoint = self.endPOI;
    if (!endPoint) {
        if ([self.endField.text isEqualToString:self.droppedPinText]) {
            endPoint = self.mapViewController.mapView.customLocation;
        } else if ([self.endField.text isEqualToString:self.currentLocationText]) {
            endPoint = self.mapViewController.mapView.userLocation;
        }
    }
    
    __weak typeof(self) weakself = self;
    [PWRoute initRouteFrom:startPoint to:endPoint accessibility:accessibility completion:^(PWRoute *route, NSError *error) {
        if (route) {
            [weakself.mapViewController.navigationItem setRightBarButtonItem:nil];
            [weakself.tableView setHidden:YES];
            [weakself.mapView setHidden:NO];
            [weakself hideRouteHeaderView];
            
            // Notify to plot the route
            [[NSNotificationCenter defaultCenter] postNotificationName:PlotRouteNotification object:route];
        } else {
            UIAlertController *routeNotFoundAlert = [UIAlertController alertControllerWithTitle:nil message:PWLocalizedString(@"InfoRouteNotFound", @"The route couldn't be found!") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okayAction = [UIAlertAction actionWithTitle:PWLocalizedString(@"Okay", @"Okay") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself.mapViewController dismissViewControllerAnimated:YES completion:nil];
            }];
            [routeNotFoundAlert addAction:okayAction];
            [weakself.mapViewController presentViewController:routeNotFoundAlert animated:YES completion:nil];
        }
    }];
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
    [self.mapViewController.navigationItem setRightBarButtonItem:nil];
    return YES;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (!self.sectionedPOIs) {
        return;
    }
    
    NSArray *pointsOfInterestForSection = self.sectionedPOIs[indexPath.section];
    PWPointOfInterest *poi = pointsOfInterestForSection[indexPath.row];
    if (!poi) {
        return;
    }
    
    if (self.startField.isEditing) {
        [self.endField becomeFirstResponder];
        self.startField.text = poi.title;
        self.startPOI = poi;
    } else if (self.endField.isEditing) {
        [self.startField becomeFirstResponder];
        self.endField.text = poi.title;
        self.endPOI = poi;
    }
    
    [self preRouteCheck];
}

@end
