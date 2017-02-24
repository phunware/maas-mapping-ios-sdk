//
//  PWRouteInstruction+Helper.h
//  PWMapKit
//
//  Created on 8/15/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWMapKit/PWMapKit.h>

@interface PWRouteInstruction (Helper)

- (BOOL)isFirstInstruction;
- (BOOL)isLastInstruction;
- (PWRouteInstruction*)previousInstruction;
- (PWRouteInstruction*)nextInstruction;

- (BOOL)isFloorChange;
- (float)turnAngleToFaceHeadingFromCurrentBearing:(CLLocationDirection)bearing;
- (NSUInteger)indexInRoute;
- (BOOL)isEqualRouteInstruction:(PWRouteInstruction *)object;

@end
