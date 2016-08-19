//
//  PWIndoorUserLocation.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <PWLocation/PWLocation.h>

#import "PWAnnotationProtocol.h"
#import "PWDirectionsWaypointProtocol.h"

@interface PWIndoorUserLocation : PWIndoorLocation <PWAnnotationProtocol,PWDirectionsWaypointProtocol>

@property CLLocationAccuracy horizontalAccuracy;
@property NSDate *timestamp;

@end
