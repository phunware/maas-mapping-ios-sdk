//
//  RoutingDirectionsTableViewCell.m
//  PWMapKit
//
//  Created on 8/15/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PureLayout/PureLayout.h>

#import "RoutingDirectionsTableViewCell.h"
#import "PWRouteInstruction+Helper.h"
#import "RouteAccessibilityManager.h"

NSString * const RoutingDirectionsTableViewCellReuseIdentifier = @"RoutingDirectionsTableViewCellReuseIdentifier";

@interface RoutingDirectionsTableViewCell ()

@property (nonatomic, strong) PWRouteInstruction *routeInstruction;
@property (nonatomic, strong) UIImageView *currentMovementImageView;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *thenLabel;
@property (nonatomic, strong) UIImageView *turnImageView;
@property (nonatomic, strong) UILabel *turnLabel;

@end

@implementation RoutingDirectionsTableViewCell

#pragma mark - Configuration

- (void)configureRouteInstruction:(PWRouteInstruction *)routeInstruction {
    self.routeInstruction = routeInstruction;
    self.userInteractionEnabled = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self initializeAndAddAllSubviews];
    [self configureCurrentMovementImageView];
    [self configureDistanceLabel];
    [self configureThenLabel];
    [self configureTurnImageView];
    [self configureTurnLabel];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self composeAccessibityLabel];
}

- (void)composeAccessibityLabel {
    if ([self.routeInstruction isLastInstruction]) {
        self.accessibilityLabel = self.distanceLabel.text;
    } else if ([self.routeInstruction isFloorChange]) {
        self.accessibilityLabel = [NSString stringWithFormat:PWLocalizedString(@"GoStraightForXThenX", @"%@, then %@."), self.distanceLabel.text, self.turnLabel.text];
    } else if (_turnLabel.text.length > 0) {
        self.accessibilityLabel = [NSString stringWithFormat:PWLocalizedString(@"GoStraightForXThenX", @"go straight for %@, then %@."), self.distanceLabel.text, self.turnLabel.text];
    } else {
        self.accessibilityLabel = self.distanceLabel.text;
    }
}

- (void)initializeAndAddAllSubviews {
    if (self.currentMovementImageView == nil || ![self.currentMovementImageView isDescendantOfView:self]) {
        self.currentMovementImageView = [UIImageView new];
        [self addSubview:self.currentMovementImageView];
    }
    if (self.distanceLabel == nil || ![self.distanceLabel isDescendantOfView:self]) {
        self.distanceLabel = [UILabel new];
        [self addSubview:self.distanceLabel];
    }
    if (self.thenLabel == nil || ![self.thenLabel isDescendantOfView:self]) {
        self.thenLabel = [UILabel new];
        [self addSubview:self.thenLabel];
    }
    if (self.turnImageView == nil || ![self.turnImageView isDescendantOfView:self]) {
        self.turnImageView = [UIImageView new];
        [self addSubview:self.turnImageView];
    }
    if (self.turnLabel == nil || ![self.turnLabel isDescendantOfView:self]) {
        self.turnLabel = [UILabel new];
        [self addSubview:self.turnLabel];
    }
}

- (void)configureCurrentMovementImageView {
    self.currentMovementImageView.image = [CommonSettings imageFromDirection:self.routeInstruction.movementDirection];
    
    [self.currentMovementImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.distanceLabel];
    [self.currentMovementImageView autoSetDimensionsToSize:CGSizeMake(45, 45)];
    [self.currentMovementImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kHorizontalOffset];
}

- (void)configureDistanceLabel {
    if ([self.routeInstruction isFloorChange] || [self.routeInstruction isLastInstruction]) {
        self.distanceLabel.text = self.routeInstruction.movement;
    } else {
        self.distanceLabel.text = [[RouteAccessibilityManager sharedInstance] distanceFormat:self.routeInstruction.distance];
    }
    self.distanceLabel.numberOfLines = 0;
    self.distanceLabel.font = [UIFont boldSystemFontOfSize:22.0];
    self.distanceLabel.textColor = [UIColor darkGrayColor];
    
    [self.distanceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.currentMovementImageView withOffset:8];
    [self.distanceLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kHorizontalOffset];
    [self.distanceLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalOffset];
}

- (void)configureThenLabel {
    if (![self.routeInstruction isLastInstruction]) {
        self.thenLabel.text = PWLocalizedString(@"ThenColon",@"Then:");
    } else {
        self.thenLabel.text = @"";
    }
    [self.thenLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.thenLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.thenLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.distanceLabel];
    [self.thenLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.turnLabel];
}

- (void)configureTurnImageView {
    if (![self.routeInstruction isLastInstruction]) {
        self.turnImageView.hidden = NO;
    } else {
        self.turnImageView.hidden = YES;
    }
    self.turnImageView.image = [CommonSettings imageFromDirection:self.routeInstruction.turnDirection];
    
    [self.turnImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.thenLabel withOffset:5];
    [self.turnImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.thenLabel];
    [self.turnImageView autoSetDimensionsToSize:CGSizeMake(20, 20)];
}

- (void)configureTurnLabel {
    if (self.routeInstruction.isLastInstruction) {
        self.turnLabel.text = @"";
    } else if ([self.routeInstruction nextInstruction].isFloorChange) {
        self.turnLabel.text = self.routeInstruction.turn;
    } else {
        self.turnLabel.text = [[RouteAccessibilityManager sharedInstance] orientationFormat:self.routeInstruction.turnAngle];
    }
    
    self.turnLabel.numberOfLines = 0;
    self.turnLabel.font = [UIFont systemFontOfSize:17.0];
    self.turnLabel.textColor = [UIColor darkGrayColor];
    
    [self.turnLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.turnImageView withOffset:5];
    [self.turnLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kHorizontalOffset];
    [self.turnLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalOffset];
    [self.turnLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.distanceLabel];
}

#pragma mark - Current Instruction Updates

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
