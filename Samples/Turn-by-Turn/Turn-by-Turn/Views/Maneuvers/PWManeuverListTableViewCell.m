//
//  PWManeuverListViewTableViewCell.m
//  Turn-by-Turn
//
//  Created by Phunware on 4/29/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "PWManeuverListTableViewCell+Private.h"
#import "PWManeuverDisplayHelper.h"

@implementation PWManeuverListTableViewCell


- (void)configureWithManeuver:(PWRouteManeuver*)maneuver withCompletedState:(BOOL)completed inMapView:(PWMapView*)mapView {
    NSParameterAssert(maneuver);
    NSParameterAssert([maneuver isKindOfClass:[PWRouteManeuver class]] == YES);
    
    NSString *descriptionString = [PWManeuverDisplayHelper descriptionForManeuver:maneuver inMapView:mapView];
    
    if (completed) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:descriptionString];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@1
                                range:NSMakeRange(0, [attributeString length])];
        self.maneuverDescription.attributedText = attributeString;
        self.maneuverDescription.textColor = [UIColor grayColor];
    }else{
        self.maneuverDescription.text = descriptionString;
        self.maneuverDescription.textColor = [UIColor blackColor];
    }
    
    self.blueView.hidden = !completed;
    
    if (maneuver.nextManeuver) {
        self.maneuverImage.image = [UIImage imageNamed:[PWManeuverDisplayHelper imageNameForManeuver:maneuver inMapView:mapView]];
    }else{
        self.maneuverImage.image = [UIImage imageNamed:[PWManeuverDisplayHelper destinationImageNameWithLastManeuver:maneuver]];
    }
    
    [self setSeparatorInset:UIEdgeInsetsZero];
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [self setPreservesSuperviewLayoutMargins:NO];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = self.bounds;
    
    self.maneuverDescription.preferredMaxLayoutWidth = CGRectGetWidth(self.maneuverDescription.frame);
    [self.maneuverDescription setNeedsUpdateConstraints];
}

@end
