//
//  PWIndoorLocation+Helper.h
//  Maps-Samples
//
//  Created on 9/23/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWLocation/PWLocation.h>

@interface PWIndoorLocation (Helper)

- (CLLocationDistance)distanceTo:(CLLocationCoordinate2D)locationCoordinate;

@end
