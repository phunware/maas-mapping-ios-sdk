//
//  POIDetailsSummaryCell.m
//  PWMapKit
//
//  Created on 9/9/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PureLayout/PureLayout.h>

#import "POIDetailsSummaryCell.h"

NSString * const POIDetailsSummaryCellReuseIdentifier = @"POIDetailsSummaryCellReuseIdentifier";

@interface POIDetailsSummaryCell ()

@property (nonatomic, strong) UILabel *summaryLabel;
@property (nonatomic, strong) NSString *summaryString;

@end

@implementation POIDetailsSummaryCell

- (void)configureForSummary:(NSString *)summary {
    self.summaryString = summary;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self initializeAndAddAllSubviews];
    [self configureSummaryCell];
}

- (void)initializeAndAddAllSubviews {
    if (self.summaryLabel == nil || ![self.summaryLabel isDescendantOfView:self]) {
        self.summaryLabel = [UILabel new];
        [self addSubview:self.summaryLabel];
    }
}

- (void)configureSummaryCell {
    self.summaryLabel.text = self.summaryString;
    self.summaryLabel.numberOfLines = 0;
    self.summaryLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.summaryLabel.textColor = [UIColor darkGrayColor];
    
    [self.summaryLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0)];
}

@end
