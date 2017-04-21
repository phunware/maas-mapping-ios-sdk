//
//  RoutingDirectionsViewController.m
//  PWMapKit
//
//  Created on 8/15/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PureLayout/PureLayout.h>

#import "RoutingDirectionsTableView.h"
#import "RoutingDirectionsTableViewCell.h"
#import "RouteAccessibilityManager.h"
#import "PWRouteInstruction+Helper.h"
#import "CommonSettings.h"

@interface RoutingDirectionsTableView () <UITableViewDelegate, UITableViewDataSource, RouteAccessibilityManagerDelegate>

@property (nonatomic, strong) PWRoute *route;
@property (nonatomic, strong) PWRouteInstruction *selectedInstruction;
@property (nonatomic, strong) UILabel *orientationLabel;
@property (nonatomic) BOOL didGetRightOriention;

@end

@implementation RoutingDirectionsTableView

- (instancetype)initWithRoute:(PWRoute *)route {
    self = [super init];
    
    if (self) {
        [RouteAccessibilityManager sharedInstance].delegate = self;
        [RouteAccessibilityManager sharedInstance].currentRouteInstruction = route.routeInstructions[0];
        
        _route = route;
        _didGetRightOriention = NO;
        _selectedInstruction = nil;
        
        self.delegate = self;
        self.dataSource = self;
        self.allowsMultipleSelection = NO;
        
        [self registerClass:[RoutingDirectionsTableViewCell class] forCellReuseIdentifier:RoutingDirectionsTableViewCellReuseIdentifier];
    }
    
    return self;
}

#pragma mark - Private

- (RoutingDirectionsTableViewCell *)cellByRouteInstruction:(PWRouteInstruction *)routeInstruction {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[routeInstruction indexInRoute] inSection:0];
    return [self cellForRowAtIndexPath:indexPath];
}

- (void)voiceOver:(NSString *)accessibilityLabel forRouteInstruction:(PWRouteInstruction *)routeInstruction {
    _selectedInstruction = routeInstruction;
    
    if (!_didGetRightOriention) {
        // Don't speak before getting right orientation
        return;
    }
    
    @synchronized (self) {
        NSLog(@"VO(%@):::::::::::::::::::::::::%@", @([routeInstruction indexInRoute]), accessibilityLabel);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[routeInstruction indexInRoute] inSection:0];
        // Select first
        [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        // Voice over
        RoutingDirectionsTableViewCell *routeInstructionCell = [self cellForRowAtIndexPath:indexPath];
        routeInstructionCell.accessibilityLabel = accessibilityLabel;
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, routeInstructionCell);
    }
}

- (void)voiceOverCurrentRouteInstruction {
    if (!_selectedInstruction) {
        _selectedInstruction = _route.routeInstructions.firstObject;
    }
    
    [self voiceOver:[self cellByRouteInstruction:_selectedInstruction].accessibilityLabel forRouteInstruction:_selectedInstruction];
}

#pragma mark - RouteAccessibilityManagerDelegate

- (void)shouldResetRouteInstruction:(PWRouteInstruction *)routeInstruction {
    [[self cellByRouteInstruction:routeInstruction] composeAccessibityLabel];
}

- (void)routeInstruction:(PWRouteInstruction *)routeInstruction didStartRouteInstructionVO:(NSString *)voiceOver {
    [self voiceOver:voiceOver forRouteInstruction:routeInstruction];
}

- (void)routeInstruction:(PWRouteInstruction *)routeInstruction willEndRouteInstructionVO:(NSString *)voiceOver {
    [self voiceOver:voiceOver forRouteInstruction:routeInstruction];
}

- (void)routeInstruction:(PWRouteInstruction *)routeInstruction didLongDistanceMoveVO:(NSString *)voiceOver {
    [self voiceOver:voiceOver forRouteInstruction:routeInstruction];
}

- (void)routeInstruction:(PWRouteInstruction *)routeInstruction didChangeOrientationVO:(NSString *)voiceOver  onRightOrientation:(BOOL)rightOrientation {
    if ([voiceOver isEqualToString:self.orientationLabel.text]) {
        return;
    }
    
    BOOL needVoiceOver = !_didGetRightOriention;
    BOOL needStartRoute = ((!_didGetRightOriention) && rightOrientation);
    if (rightOrientation) {
        self.orientationLabel.text = PWLocalizedString(@"OnRightOrientation", @"You are on the right orientation.");
        _didGetRightOriention = YES;
    } else {
        self.orientationLabel.text = voiceOver;
    }
    
    if (needVoiceOver) {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.orientationLabel);
    }
    
    if (needStartRoute) {
        [self voiceOverCurrentRouteInstruction];
    }
}

- (void)routeInstruction:(PWRouteInstruction *)routeInstruction arrivingDestination:(NSString *)voiceOver {
    [self voiceOver:voiceOver forRouteInstruction:routeInstruction];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.route.routeInstructions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 130.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [CommonSettings commonViewForgroundColor];
    UILabel *first = [[UILabel alloc] initWithFrame:CGRectZero];
    first.font = [UIFont systemFontOfSize:17.0];
    first.textColor = [UIColor darkGrayColor];
    first.text = PWLocalizedString(@"NavigatingTo", @"NAVIGATING TO:");
    first.backgroundColor = [CommonSettings commonViewForgroundColor];
    [headerView addSubview:first];
    [first autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kStandardLineSpace];
    [first autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kStandardSpace];
    [first autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    UILabel *second = [[UILabel alloc] initWithFrame:CGRectZero];
    second.font = [UIFont boldSystemFontOfSize:20.0];
    second.textColor = [UIColor darkGrayColor];
    second.text = self.route.endPoint.title;
    second.backgroundColor = [CommonSettings commonViewForgroundColor];
    [headerView addSubview:second];
    [second autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:first withOffset:kStandardLineSpace];
    [second autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kStandardSpace];
    [second autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    UILabel *third = [[UILabel alloc] initWithFrame:CGRectZero];
    third.font = [UIFont boldSystemFontOfSize:17.0];
    third.textColor = [UIColor darkGrayColor];
    third.text = [self.route.building getFloorByFloorId:self.route.endPoint.floorID].name;
    third.backgroundColor = [CommonSettings commonViewForgroundColor];
    [headerView addSubview:third];
    [third autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:second withOffset:kStandardLineSpace];
    [third autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kStandardSpace];
    [third autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    UIView *lastBg = [[UIView alloc] initWithFrame:CGRectZero];
    lastBg.backgroundColor = [UIColor clearColor];
    [headerView addSubview:lastBg];
    [lastBg autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:third withOffset:kStandardLineSpace];
    [lastBg autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [lastBg autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [lastBg autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    self.orientationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.orientationLabel.font = [UIFont boldSystemFontOfSize:20.0];
    self.orientationLabel.textColor = [UIColor lightGrayColor];
    self.orientationLabel.text = PWLocalizedString(@"RightOrientation", @"Trying to detect your orientation.");
    [lastBg addSubview:self.orientationLabel];
    [self.orientationLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, kStandardSpace, 0, 0)];
    
    headerView.accessibilityElements = @[self.orientationLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoutingDirectionsTableViewCell *routeInstructionCell = [tableView dequeueReusableCellWithIdentifier:RoutingDirectionsTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    [routeInstructionCell configureRouteInstruction:self.route.routeInstructions[indexPath.row]];
    
    return routeInstructionCell;
}

@end
