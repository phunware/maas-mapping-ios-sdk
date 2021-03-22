//
//  PWDebugDotManager.h
//  PWMapKit
//
//  Created by Patrick Dunshee on 5/24/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWMapView;

@interface PWDebugDotManager : NSObject

- (instancetype)initWithPWMapView:(PWMapView *)mapView;

- (BOOL)annotationIsDebugDot:(id<MKAnnotation>)annotation;
- (MKAnnotationView *)annotationViewForDebugAnnotation:(id<MKAnnotation>)annotation;
- (void)startListeningForUpdates;
- (void)removeAllDebugDotsAndStop;

@end
