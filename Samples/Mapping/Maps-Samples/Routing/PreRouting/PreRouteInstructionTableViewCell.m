//
//  PreRouteInstructionTableViewCell.m
//  PWMapKit
//
//  Created on 8/11/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PureLayout/PureLayout.h>

#import "PreRouteInstructionTableViewCell.h"
#import "PWRouteInstruction+Helper.h"
#import "RouteAccessibilityManager.h"
#import "CommonSettings.h"

NSString * const PreRouteInstructionCellReuseIdentifier = @"PreRouteInstructionCell";

@interface PreRouteInstructionTableViewCell ()

@property (nonatomic, strong) PWRouteInstruction *routeInstruction;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *movementLabel;

@end

@implementation PreRouteInstructionTableViewCell

- (void)configureForRouteInstruction:(PWRouteInstruction *)routeInstruction {
    self.routeInstruction = routeInstruction;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self initializeAndAddAllSubviews];
    [self configureDistanceLabel];
    [self configureMovementLabel];
    
    if (![self.routeInstruction isLastInstruction]) {
        NSString *distanceAccessibilityString = [NSString stringWithFormat:PWLocalizedString(@"GoStraightForX", @"Go straight for %@"), self.distanceLabel.text];
        self.accessibilityLabel = [NSString stringWithFormat:@"%@ %@", distanceAccessibilityString, self.movementLabel.text];
    } else {
        self.accessibilityLabel = self.distanceLabel.text;
    }
}

- (void)initializeAndAddAllSubviews {
    if (self.distanceLabel == nil || ![self.distanceLabel isDescendantOfView:self]) {
        self.distanceLabel = [UILabel new];
        [self addSubview:self.distanceLabel];
    }
    if (self.movementLabel == nil || ![self.movementLabel isDescendantOfView:self]) {
        self.movementLabel = [UILabel new];
        [self addSubview:self.movementLabel];
    }
}

- (void)configureDistanceLabel {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.formatterBehavior = NSNumberFormatterBehavior10_4;
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.roundingMode = NSNumberFormatterRoundCeiling;
    formatter.maximumFractionDigits = 0;
    if ([self.routeInstruction isFloorChange] || [self.routeInstruction isLastInstruction]) {
        self.distanceLabel.text = self.routeInstruction.movement;
    } else {
        self.distanceLabel.text = [[RouteAccessibilityManager sharedInstance] distanceFormat:self.routeInstruction.distance];
    }
    self.distanceLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.distanceLabel.textColor = [UIColor blackColor];
    self.distanceLabel.numberOfLines = 0;
    
    [self.distanceLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
    [self.distanceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0];
    [self.distanceLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0];
}

- (void)configureMovementLabel {
    if ([self.routeInstruction isLastInstruction]) {
        self.movementLabel.text = @"";
        return;
    }
    self.movementLabel.text = self.routeInstruction.turn;
    self.movementLabel.font = [UIFont systemFontOfSize:17.0];
    self.movementLabel.textColor = [UIColor darkGrayColor];
    self.movementLabel.numberOfLines = 0;
    
    [self.movementLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0];
    [self.movementLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0];
    [self.movementLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
    [self.movementLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.distanceLabel];
}

@end
