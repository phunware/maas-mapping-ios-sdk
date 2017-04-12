//
//  PWMapKit.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 6/23/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PWMapKit/PWMapView.h>
#import <PWMapKit/PWBuilding.h>
#import <PWMapKit/PWFloor.h>
#import <PWMapKit/PWPointOfInterest.h>
#import <PWMapKit/PWPointOfInterestType.h>
#import <PWMapKit/PWCustomLocation.h>
#import <PWMapKit/PWRoute.h>
#import <PWMapKit/PWRouteInstruction.h>
#import <PWMapKit/PWMapPoint.h>
#import <PWMapKit/PWCustomPointOfInterest.h>

/** Light weight UI **/
#import <PWMapKit/PWRouteStartView.h>
#import <PWMapKit/PWMapViewController.h>
#import <PWMapKit/PWBuildingViewController.h>
#import <PWMapKit/PWRouteViewController.h>
#import <PWMapKit/PWRouteInstructionsView.h>
#import <PWMapKit/PWRouteInstructionsViewController.h>
#import <PWMapKit/PWPointOfInterestViewController.h>
#import <PWMapKit/PWBuildingAnnotationView.h>
#import <PWMapKit/PWAnnotationLabel.h>

@interface PWMapKit : NSObject

/**
 Returns PWMapKit.
 */
+ (NSString *)serviceName;

@end
