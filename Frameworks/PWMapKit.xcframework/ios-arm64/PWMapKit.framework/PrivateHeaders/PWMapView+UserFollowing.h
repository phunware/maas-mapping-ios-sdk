//
//  PWMapView+UserFollowing.h
//  PWMapKit
//
//  Created by Sam Odom on 2/9/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWMapView+Private.h"

@interface PWMapView (UserFollowing)

- (BOOL)shouldUseIndoorUserTrackingMode:(PWTrackingMode)mode;

- (void)startFollowing:(BOOL)useHeading;

- (void)stopFollowing;

- (BOOL)userInFollowingMode;

- (BOOL)userShouldInFollowingMode;

- (BOOL)userInDisplayingFloor;

- (BOOL)userInRoutingMode;

- (void)zoomToUser;

- (void)updatePosition:(CADisplayLink*)timer;

- (BOOL)automaticallyChangeRouteInstructionBasedOnUserLocation;

@end
