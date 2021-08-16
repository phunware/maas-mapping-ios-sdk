//
//  PWRouteSnapperDelegateProtocol.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PWRouteSnapperDelegateProtocol <NSObject>

@optional

- (void)startedSnappingToRoute;
- (void)stoppedSnappingToRoute;

@end
