//
//  POIDetailsTableViewCell.m
//  PWMapKit
//
//  Created on 9/9/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PureLayout/PureLayout.h>

#import "POIDetailsTableViewCell.h"

NSString * const POIDetailsCellReuseIdentifier = @"POIDetailsCellReuseIdentifier";

static CGFloat LeftRightMargin = 15.0;
static CGFloat TopBottomMargin = 8.0;

@interface POIDetailsTableViewCell ()

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) NSString *keyString;
@property (nonatomic, strong) NSString *valueString;

@end

@implementation POIDetailsTableViewCell

- (void)configureForKey:(NSString *)keyString value:(NSString *)valueString {
    self.keyString = keyString;
    self.valueString = valueString;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self initializeAndAddAllSubviews];
    [self configureKeyLabel];
    [self configureValueLabel];
}

- (void)initializeAndAddAllSubviews {
    if (self.keyLabel == nil || ![self.keyLabel isDescendantOfView:self]) {
        self.keyLabel = [UILabel new];
        [self addSubview:self.keyLabel];
    }
    if (self.valueLabel == nil || ![self.valueLabel isDescendantOfView:self]) {
        self.valueLabel = [UILabel new];
        [self addSubview:self.valueLabel];
    }
}

- (void)configureKeyLabel {
    self.keyLabel.text = self.keyString;
    self.keyLabel.font = [UIFont boldSystemFontOfSize:20.0];
    self.keyLabel.textColor = [UIColor blackColor];
    self.keyLabel.numberOfLines = 0;
    
    [self.keyLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:TopBottomMargin];
    [self.keyLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:LeftRightMargin];
    [self.keyLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:LeftRightMargin];
}

- (void)configureValueLabel {
    self.valueLabel.text = self.valueString;
    self.valueLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.valueLabel.textColor = [UIColor darkGrayColor];
    self.valueLabel.numberOfLines = 0;
    
    [self.valueLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.keyLabel];
    [self.valueLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:LeftRightMargin];
    [self.valueLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:LeftRightMargin];
    [self.valueLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:TopBottomMargin];
}

@end
