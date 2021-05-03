//
//  PWHeadingManager.h
//  PWMapKit
//
//  Created by Sam Odom on 1/20/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWHeadingManagerDelegateProtocol.h"

@interface PWHeadingManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id<PWHeadingManagerDelegateProtocol> delegate;

@property (readonly) CLHeading *heading;
@property CLLocationDegrees headingFilter;

- (void)startUpdatingHeading;
- (void)stopUpdatingHeading;

@end
