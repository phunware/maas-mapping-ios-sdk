//
//  PWMapKit.h
//  PWMapKit
//
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PWMapKit/PWMapView.h>
#import <PWMapKit/PWBuilding.h>
#import <PWMapKit/PWFloor.h>
#import <PWMapKit/PWPointOfInterest.h>
#import <PWMapKit/PWPointOfInterestType.h>
#import <PWMapKit/PWCustomLocation.h>
#import <PWMapKit/PWUserLocation.h>
#import <PWMapKit/PWFloorChangePOI.h>
#import <PWMapKit/PWLandmark.h>
#import <PWMapKit/PWLandmarkType.h>
#import <PWMapKit/PWRoute.h>
#import <PWMapKit/PWRouteInstruction.h>
#import <PWMapKit/PWRouteOptions.h>
#import <PWMapKit/PWRouteUIOptions.h>
#import <PWMapKit/PWMapPoint.h>
#import <PWMapKit/PWCustomPointOfInterest.h>
#import <PWMapKit/PWBuildingAnnotationView.h>
#import <PWMapKit/PWAnnotationLabel.h>
#import <PWMapKit/PWSharedLocation.h>
#import <PWMapKit/PWLocationSharingDelegate.h>

static NSString *const PWMapKitVersion = @"3.9.1";

@interface PWMapKit : NSObject

/**
 Returns PWMapKit.
 */
+ (NSString *)serviceName;

@end
