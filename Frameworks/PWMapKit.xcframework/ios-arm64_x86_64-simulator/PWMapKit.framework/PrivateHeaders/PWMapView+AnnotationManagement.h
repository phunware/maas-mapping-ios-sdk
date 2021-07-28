//
//  PWMapView+AnnotationManagement.h
//  PWMapKit
//
//  Created by Sam Odom on 12/1/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWMapView+Private.h"

@interface PWMapView (AnnotationManagement)

- (void)refreshAnnotations;
- (void)refreshUserLocationAnnotation;
- (void)addUserLocationAnnotation;
- (void)removeUserLocationAnnotation;

@end
