//
//  PWSerialization.h
//  PWMapKit
//
//  Created by Sam Odom on 10/22/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

CLLocationCoordinate2D CoordinateFromValues(NSDictionary *dictionary);

id NilIfNull(id value);

NSUInteger UnsignedIntegerFromValue(id value);
NSInteger SignedIntegerFromValue(id value);
double DoubleFromValue(id value);
BOOL BooleanFromValue(id value);
