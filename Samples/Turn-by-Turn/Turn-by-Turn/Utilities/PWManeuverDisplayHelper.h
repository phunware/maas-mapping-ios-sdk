//
//  PWManeuverDisplayHelper.h
//  Turn-by-Turn
//
//  Created by Phunware on 4/29/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWMapKit/PWMapKit.h>
#import <PWMapKit/PWRouteManeuver.h>

@interface PWManeuverDisplayHelper : NSObject

+ (NSString *)descriptionForManeuver:(PWRouteManeuver *)maneuver inMapView:(PWMapView *)mapview;
+ (NSString *)imageNameForManeuver:(PWRouteManeuver *)maneuver inMapView:(PWMapView *)mapview;
+ (NSString *)destinationImageNameWithLastManeuver:(PWRouteManeuver *)maneuver;
+ (NSString *)distanceStringUsingDistance:(CLLocationDistance)distance;

@end
