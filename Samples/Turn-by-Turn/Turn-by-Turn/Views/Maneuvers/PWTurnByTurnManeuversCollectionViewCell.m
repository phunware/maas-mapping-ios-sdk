//
//  PWTurnByTurnManeuversCollectionViewCell.m
//  Turn-by-Turn
//
//  Created by Phunware on 4/23/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "PWTurnByTurnManeuversCollectionViewCell+Private.h"
#import "PWManeuverDisplayHelper.h"

NSString * const PWTurnByTurnManeuversAlphaNotification = @"PWTurnByTurnManeuversAlphaNotification";
NSString * const PWTurnByTurnManeuversAlphaNotificationAlphaKey = @"PWTurnByTurnManeuversAlphaNotificationAlphaKey";
NSString * const PWTurnByTurnManeuversAlphaNotificationManeuverKey = @"PWTurnByTurnManeuversAlphaNotificationManeuverKey";

@implementation PWTurnByTurnManeuversCollectionViewCell

- (void)configureWithManeuver:(PWRouteManeuver*)maneuver inMapView:(PWMapView*)mapview {
    [self configureWithManeuver:maneuver inMapView:mapview flatAppearance:NO];
}

- (void)configureWithManeuver:(PWRouteManeuver*)maneuver inMapView:(PWMapView*)mapview flatAppearance:(BOOL)flatAppearance {
    NSParameterAssert(maneuver);
    NSParameterAssert([maneuver isKindOfClass:[PWRouteManeuver class]] == YES);
    
    if (!self.currentManeuver) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alphaNotification:) name:PWTurnByTurnManeuversAlphaNotification object:nil];
    }
    
    if (self.currentManeuver.index != maneuver.index) {
        [self setContentsAlpha:1];
    }
    
    self.currentManeuver = maneuver;
    self.maneuverDescription.text = [PWManeuverDisplayHelper descriptionForManeuver:maneuver inMapView:mapview];
    
    if (maneuver.nextManeuver) {
        self.maneuverImage.image = [UIImage imageNamed:[PWManeuverDisplayHelper imageNameForManeuver:maneuver inMapView:mapview]];
        
        [self setNextManueverItemsHiddenState:NO];
        self.nextManeuverDescription.text = [PWManeuverDisplayHelper descriptionForManeuver:maneuver.nextManeuver inMapView:mapview];
        self.nextManeuverImage.image = [UIImage imageNamed:[PWManeuverDisplayHelper imageNameForManeuver:maneuver.nextManeuver inMapView:mapview]];
    }else{
        self.maneuverImage.image = [UIImage imageNamed:[PWManeuverDisplayHelper destinationImageNameWithLastManeuver:maneuver]];
        
        [self setNextManueverItemsHiddenState:YES];
    }
    
    if (!maneuver.nextManeuver) {
        self.rightBorder.hidden = YES;
    }else{
        self.rightBorder.hidden = !flatAppearance;
    }
}

-(void)setNextManueverItemsHiddenState:(BOOL)hidden {
    self.nextManeuverDescription.hidden = hidden;
    self.nextManeuverImage.hidden = hidden;
    self.nextLabel.hidden = hidden;
    
    if (hidden) {
        if ([self.nextManeuverVisibleLayoutHeightConstraint respondsToSelector:@selector(active)]) {
            self.nextManeuverVisibleLayoutHeightConstraint.active = NO;
        }else{
            self.nextManeuverVisibleLayoutHeightConstraint.constant = -30;
        }
    }else{
        if ([self.nextManeuverVisibleLayoutHeightConstraint respondsToSelector:@selector(active)]) {
            self.nextManeuverVisibleLayoutHeightConstraint.active = YES;
        }else{
            self.nextManeuverVisibleLayoutHeightConstraint.constant = 14;
        }
    }
}

- (void)alphaNotification:(NSNotification*)notification {
    PWRouteManeuver *notificationManeuver = notification.userInfo[PWTurnByTurnManeuversAlphaNotificationManeuverKey];
    NSNumber *notificationAlpha = notification.userInfo[PWTurnByTurnManeuversAlphaNotificationAlphaKey];
    if (notificationManeuver.index == self.currentManeuver.index) {
        [self setContentsAlpha:notificationAlpha.doubleValue];
    }
}

- (void)setContentsAlpha:(CGFloat)alphaValue {
    CGFloat adjustedAlpha = alphaValue;
    adjustedAlpha = sqrt(adjustedAlpha);
    self.maneuverDescription.alpha = adjustedAlpha;
    self.nextManeuverDescription.alpha = adjustedAlpha;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = self.bounds;
    [self updatePreferedWidthInLabels];
    
}

- (void)updatePreferedWidthInLabels {
    if (self.currentManeuver)
    {
        self.maneuverDescription.preferredMaxLayoutWidth = CGRectGetWidth(self.maneuverDescription.frame);
        [self.maneuverDescription setNeedsUpdateConstraints];
        
        self.nextManeuverDescription.preferredMaxLayoutWidth = CGRectGetWidth(self.nextManeuverDescription.frame);
        [self.nextManeuverDescription setNeedsUpdateConstraints];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
