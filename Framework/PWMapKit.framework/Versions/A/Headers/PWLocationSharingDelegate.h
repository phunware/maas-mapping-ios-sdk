//
//  PWSharingManagerDelegate.h
//  PWMapKit
//
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWSharedLocation;

@protocol PWLocationSharingDelegate <NSObject>

/**
 *  Tells the delegate that it has retrieved all shared locations
 *
 *  @param sharedLocations The current list of all shared locations
 *
 */
- (void)didUpdateSharedLocations:(NSSet<PWSharedLocation *> *)sharedLocations;

@optional

/**
 *  Passes a set of only added shared locations to the delegate
 *
 *  @param addedSharedLocations Shared locations that just started sharing
 *
 */
- (void)didAddSharedLocations:(NSSet<PWSharedLocation *> *)addedSharedLocations;

/**
 *  Passes a set of only removed shared locations to the delegate
 *
 *  @param removedSharedLocations Shared locations that just stopped sharing
 *
 */
- (void)didRemoveSharedLocations:(NSSet<PWSharedLocation *> *)removedSharedLocations;

@end
