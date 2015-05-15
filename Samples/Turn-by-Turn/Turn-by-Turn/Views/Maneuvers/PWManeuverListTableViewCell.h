//
//  PWManeuverListViewTableViewCell.h
//  Turn-by-Turn
//
//  Created by Phunware on 4/29/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PWMapKit/PWMapKit.h>
#import <PWMapKit/PWRouteManeuver.h>

@interface PWManeuverListTableViewCell : UITableViewCell

- (void)configureWithManeuver:(PWRouteManeuver*)maneuver withCompletedState:(BOOL)completed inMapView:(PWMapView*)mapView;

@end
