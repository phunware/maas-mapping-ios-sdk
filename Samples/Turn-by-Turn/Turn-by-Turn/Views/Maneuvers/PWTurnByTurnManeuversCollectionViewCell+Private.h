//
//  PWTurnByTurnManeuversCollectionViewCell+Private.h
//  PWMapKit
//
//  Created by Phunware on 5/4/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWTurnByTurnManeuversCollectionViewCell.h"

@interface PWTurnByTurnManeuversCollectionViewCell()

@property (nonatomic,weak) IBOutlet UILabel *maneuverDescription;
@property (nonatomic,weak) IBOutlet UIImageView *maneuverImage;
@property (nonatomic,weak) IBOutlet UILabel *nextManeuverDescription;
@property (nonatomic,weak) IBOutlet UILabel *nextLabel;
@property (nonatomic,weak) IBOutlet UIImageView *nextManeuverImage;
@property (nonatomic,weak) PWRouteManeuver *currentManeuver;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint *nextManeuverVisibleLayoutHeightConstraint;

@end