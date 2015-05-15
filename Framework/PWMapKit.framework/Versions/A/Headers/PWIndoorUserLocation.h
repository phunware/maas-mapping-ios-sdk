//
//  PWIndoorUserLocation.h
//  PWMapKit
//
//  Created by Sam Odom on 3/4/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <PWLocation/PWLocation.h>

#import "PWAnnotationProtocol.h"
#import "PWDirectionsWaypointProtocol.h"

@interface PWIndoorUserLocation : PWIndoorLocation <PWAnnotationProtocol,PWDirectionsWaypointProtocol>

@property CLLocationAccuracy horizontalAccuracy;
@property NSDate *timestamp;

@end
