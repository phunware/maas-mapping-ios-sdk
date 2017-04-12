//
//  PWBeaconRegion.h
//  PWLocation
//
//  Created by Illya Busigin on 5/28/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PWBeaconProximityRegion : NSObject <NSSecureCoding, NSCopying>

@property (nonatomic, readonly) CLBeaconRegion *region;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSUInteger floorIdentifier;

- (instancetype)initWithBeaconRegion:(CLBeaconRegion *)region coordinate:(CLLocationCoordinate2D)coordinate floorIdentifier:(NSUInteger)floorIdentifier NS_DESIGNATED_INITIALIZER;

@end