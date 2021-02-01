//
//  PWRouteSnapperDelegateProtocol.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

@protocol PWRouteSnapperDelegateProtocol <NSObject>

@optional

- (void)startedSnappingToRoute;
- (void)stoppedSnappingToRoute;

@end
