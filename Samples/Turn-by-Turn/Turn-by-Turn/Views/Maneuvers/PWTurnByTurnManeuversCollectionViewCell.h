//
//  PWTurnByTurnManeuversCollectionViewCell.h
//  Turn-by-Turn
//
//  Created by Phunware on 4/23/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PWMapKit/PWMapKit.h>
#import <PWMapKit/PWRouteManeuver.h>

extern NSString * const PWTurnByTurnManeuversAlphaNotification;
extern NSString * const PWTurnByTurnManeuversAlphaNotificationAlphaKey;
extern NSString * const PWTurnByTurnManeuversAlphaNotificationManeuverKey;


@interface PWTurnByTurnManeuversCollectionViewCell : UICollectionViewCell

@property (nonatomic,weak) IBOutlet UIView *rightBorder;

- (void)configureWithManeuver:(PWRouteManeuver*)maneuver inMapView:(PWMapView*)mapview;

- (void)configureWithManeuver:(PWRouteManeuver*)maneuver inMapView:(PWMapView*)mapview flatAppearance:(BOOL)flatAppearance;

- (void)updatePreferedWidthInLabels;

@end
