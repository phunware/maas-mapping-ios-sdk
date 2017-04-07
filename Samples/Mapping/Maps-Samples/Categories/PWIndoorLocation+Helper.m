//
//  PWIndoorLocation+Helper.m
//  Maps-Samples
//
//  Created on 9/23/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "PWIndoorLocation+Helper.h"

@implementation PWIndoorLocation(Helper)

- (CLLocationDistance)distanceTo:(CLLocationCoordinate2D)locationCoordinate {
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:locationCoordinate.latitude longitude:locationCoordinate.longitude];
    return [startLocation distanceFromLocation:endLocation];
}

@end
