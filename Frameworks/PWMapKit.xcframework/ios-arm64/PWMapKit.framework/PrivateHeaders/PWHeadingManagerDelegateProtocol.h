//
//  PWHeadingManagerDelegateProtocol.h
//  PWMapKit
//
//  Created by Sam Odom on 1/20/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

@class PWHeadingManager;

@protocol PWHeadingManagerDelegateProtocol <NSObject>

@optional

- (void)headingManager:(PWHeadingManager*)headingManager didUpdateHeading:(CLHeading*)heading;
- (BOOL)headingManagerShouldDisplayHeadingCalibration:(PWHeadingManager*)headingManager;

@end