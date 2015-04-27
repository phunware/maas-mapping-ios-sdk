//
//  POITableViewCell.m
//  POI Management
//
//  Created by Illya Busigin on 4/13/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "POITableViewCell.h"

@interface POITableViewCell ()

@property (weak) UIImageView *annotationImageView;
@property (weak) UILabel *annotationTitleLabel;
@property (weak) UILabel *annotationTypeLabel;

@end

@implementation POITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    UIImageView *annotationImageView = [UIImageView new];
    annotationImageView.frame = CGRectMake(0, 0, 44, 44);
    annotationImageView.contentMode = UIViewContentModeCenter;
    annotationImageView.translatesAutoresizingMaskIntoConstraints = NO;
    annotationImageView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:annotationImageView];
    self.annotationImageView = annotationImageView;
    
    UILabel *annotationTitleLabel = [UILabel new];
    annotationTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:annotationTitleLabel];
    self.annotationTitleLabel = annotationTitleLabel;
    
    UILabel *annotationTypeLabel = [UILabel new];
    annotationTypeLabel.font = [UIFont systemFontOfSize:11.f];
    annotationTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:annotationTypeLabel];
    self.annotationTypeLabel = annotationTypeLabel;
    
    // Setup constraints
    NSDictionary *bindings = NSDictionaryOfVariableBindings(annotationImageView, annotationTitleLabel, annotationTypeLabel);
    
    NSArray *constraints = @[
                             @"V:|-0-[annotationImageView(44)]",
                             @"H:|-0-[annotationImageView(44)]",
                             @"V:|-3-[annotationTitleLabel]-0-[annotationTypeLabel]-3-|",
                             @"H:|[annotationImageView]-5-[annotationTitleLabel]|",
                             @"H:|[annotationImageView]-5-[annotationTypeLabel]|"
                             ];
    
    for (NSString *constraint in constraints) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:bindings]];
    }
}

@end
