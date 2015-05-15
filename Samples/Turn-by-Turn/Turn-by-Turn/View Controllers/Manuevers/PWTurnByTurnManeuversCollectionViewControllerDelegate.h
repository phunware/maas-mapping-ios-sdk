//
//  PWTurnByTurnManeuversCollectionViewControllerDelegate.h
//  PWMapKit
//
//  Created by Phunware on 5/4/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PWTurnByTurnManeuversCollectionViewControllerDelegate <NSObject>

@optional
- (void)turnByTurnManeuversViewDidScrollToManeuver:(PWRouteManeuver*)maneuver triggeredByUser:(BOOL)triggeredByUser;

- (void)turnByTurnManeuversViewDidChangeFloor:(PWBuildingFloorIdentifier)floorId triggeredByUser:(BOOL)triggeredByUser;

@end
