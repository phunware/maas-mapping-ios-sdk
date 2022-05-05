//
//  PWRouteSegment+Private.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PWRouteSegment.h"

@interface PWRouteSegment ()

@property (nonatomic) NSInteger floorID;
@property (nonatomic) PWAnnotationIdentifier startPointID;
@property (nonatomic) PWAnnotationIdentifier endPointID;
@property (nonatomic) CLLocationDistance distance;

@end
