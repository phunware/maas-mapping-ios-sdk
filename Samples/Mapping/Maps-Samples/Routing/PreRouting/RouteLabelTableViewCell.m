//
//  RouteLabelTableViewCell.m
//  PWMapKit
//
//  Created on 8/12/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PureLayout/PureLayout.h>

#import "RouteLabelTableViewCell.h"
#import "CommonSettings.h"

NSString * const RouteLabelTableViewCellReuseIdentifier = @"RouteLabelTableViewCellReuseIdentifier";

@interface RouteLabelTableViewCell ()

@property (nonatomic, strong) UILabel *routeLabel;

@end

@implementation RouteLabelTableViewCell

- (void)configure {
    self.routeLabel = [UILabel new];
    self.routeLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.routeLabel.textColor = [UIColor blackColor];
    self.routeLabel.text = PWLocalizedString(@"RouteColon", @"Route:");
    
    [self addSubview:self.routeLabel];
    
    [self.routeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
    [self.routeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0];
    [self.routeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0];
    [self.routeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
}

@end
