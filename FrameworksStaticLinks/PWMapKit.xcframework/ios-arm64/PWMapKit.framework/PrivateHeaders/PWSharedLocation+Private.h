//
//  PWSharedLocation+Private.h
//  LocationDiagnostic
//
//  Created by Chesley Stephens on 5/19/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import "PWSharedLocation.h"

extern NSString *const PWSharedLocationVenueGuidKey;
extern NSString *const PWSharedLocationBuildingIdKey;
extern NSString *const PWSharedLocationFloorIdKey;
extern NSString *const PWSharedLocationDeviceIdKey;
extern NSString *const PWSharedLocationLocationKey;
extern NSString *const PWSharedLocationLatitudeKey;
extern NSString *const PWSharedLocationLongitudeKey;
extern NSString *const PWSharedLocationSourceKey;
extern NSString *const PWSharedLocationConfidenceFactorKey;
extern NSString *const PWSharedLocationDisplayNameKey;
extern NSString *const PWSharedLocationUserTypeKey;

@interface PWSharedLocation ()

@property (nonatomic, strong) NSNumber *buildingId;
@property (nonatomic, strong) NSNumber *floorId;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSNumber *confidenceFactor;
@property (nonatomic, strong) NSString *userType;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
