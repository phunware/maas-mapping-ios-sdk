//
//  PWMapView+UserLocationGovernance.h
//  PWMapKit
//
//  Created by Sam Odom on 2/9/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWMapView+Private.h"

@interface PWMapView (UserLocationGovernance)

- (void)startUserLocationDisplayUpdates;
- (void)stopUserLocationDisplayUpdates;
- (void)headingUpdated:(NSNotification *)notification;
- (void)applyHeading:(CLLocationDirection)updateHeading accuracy:(CLLocationDirection)accuracy;

@end
