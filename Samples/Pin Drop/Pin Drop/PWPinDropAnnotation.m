//
//  PWPinDropAnnotation.m
//  Pin Drop
//
//  Created by Illya Busigin on 4/13/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "PWPinDropAnnotation.h"

@implementation PWPinDropAnnotation

@synthesize coordinate = _coordinate;
@synthesize floorID;
@synthesize title;
@synthesize mapView;
@synthesize annotationID = _annotationID;

- (instancetype)init {
    if (self = [super init]) {
        _annotationID = PWAnnotationIdentifierUndefined;
    }
    
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    if (self.mapView) {
        return [self.mapView zoomWorkaroundCoordinateFromCoordinate:_coordinate];
    }
    else {
        return _coordinate;
    }
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

- (NSString *)title {
    return @"Custom Location";
}

- (NSURL*)imageURL {
    return nil;
}

@end
