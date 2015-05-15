//
//  PWManeuverListViewController+Private.h
//  PWMapKit
//
//  Created by Phunware on 5/4/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWManeuverListViewController.h"

@interface PWManeuverListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *maneuvers;

- (NSArray*)maneuversFromMap;
- (BOOL)isManeuverCompleted:(PWRouteManeuver*)maneuver;
- (PWRouteManeuver*)currentManeuver;

@end