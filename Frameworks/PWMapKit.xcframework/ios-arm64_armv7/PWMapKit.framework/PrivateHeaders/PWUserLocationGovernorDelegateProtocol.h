//
//  PWUserLocationGovernorDelegateProtocol.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PWUserLocationGovernorDelegateProtocol <NSObject>

@optional

- (void)locationUpdateSucceeded;
- (void)locationUpdateFailedWithError:(NSError*)error;

- (void)startedSnappingToRoute;
- (void)stoppedSnappingToRoute;

- (void)headingUpdated;
- (BOOL)shouldDisplayHeadingCalibration;

- (void)startedFloorTransitionMode;

@end
