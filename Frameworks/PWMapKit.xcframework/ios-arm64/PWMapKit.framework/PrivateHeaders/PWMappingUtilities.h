//
//  PWMappingUtilities.h
//  PWMapKit
//
//  Created by Sam Odom on 11/5/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "PWMapView.h"
#import "Vector2D.h"
#import "PWMapKitDefines.h"

CLLocationDirection ConvertRadiansToDegrees(double radians);

double DistanceInMapPoint(CLLocationCoordinate2D from, CLLocationCoordinate2D to);

CLLocationDistance DistanceBetweenCoordinates(CLLocationCoordinate2D coordinateOne,
                                              CLLocationCoordinate2D coordinateTwo);

CLLocationDistance DistanceBetweenMapPoints(MKMapPoint mapPointOne,
                                            MKMapPoint mapPointTwo);

BOOL CoordinatesAreEqual(CLLocationCoordinate2D coordinateOne,
                         CLLocationCoordinate2D coordinateTwo);

BOOL CoordinatesAreEqualWithAccuracy(CLLocationCoordinate2D coordinateOne,
                                     CLLocationCoordinate2D coordinateTwo,
                                     CLLocationDegrees latitudeTolerance,
                                     CLLocationDegrees longitudeTolerance);

Vector2D Vector2DFromMapPoint(MKMapPoint mapPoint);
MKMapPoint MKMapPointFromVector2D(Vector2D vector);

CLLocationDirection BearingBetweenMapPoints(MKMapPoint, MKMapPoint);

@interface PWMappingUtilities : NSObject

+ (NSError *)error:(PWMapKitErrorCode)code;

+ (NSError *)error:(NSInteger)code info:(NSString *)info;

+ (CLLocationCoordinate2D)coodinateBetween:(CLLocationCoordinate2D)from and:(CLLocationCoordinate2D)to with:(double)distanceInPoint rotate:(double)rotateAngle;

@end
