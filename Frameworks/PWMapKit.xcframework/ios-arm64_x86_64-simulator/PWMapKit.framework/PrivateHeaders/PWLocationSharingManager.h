//
//  PWLocationSharingManager.h
//  LocationDiagnostic
//
//  Created by Chesley Stephens on 5/19/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWLocationSharingDelegate.h"

@class PWSharedLocation;

@interface PWLocationSharingManager : NSObject

@property (nonatomic, weak) id<PWLocationSharingDelegate> delegate;

@property (nonatomic, strong, readonly) NSSet<PWSharedLocation *> *sharedLocations;

@property (nonatomic, strong) NSNumber *buildingId;
@property (nonatomic, strong) NSNumber *floorId;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *userType;

- (instancetype)initWithBuildingId:(NSNumber *)buildingId floorId:(NSNumber *)floorId displayName:(NSString *)displayName userType:(NSString *)userType;

- (void)startSharingUserLocation;
- (void)startRetrievingSharedLocations;

- (void)stopSharingUserLocation;
- (void)stopRetrievingSharedLocations;

- (void)updateLocation:(CLLocationCoordinate2D)location floorId:(NSNumber *)floorId;

@end
