//
//  PWMapViewDelegateProxy.h
//  PWMapKit
//
//  Created by Sam Odom on 10/15/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>

@class PWMapView;
@protocol PWMapViewDelegate;

@interface PWMapViewDelegateProxy: NSProxy<MKMapViewDelegate>

@property (weak) id<PWMapViewDelegate> delegate;
@property (weak) PWMapView *mapView;

+ (instancetype)delegateWithMapView:(PWMapView*)mapView and:(id<PWMapViewDelegate>)delegate;

- (BOOL)respondsToSelector:(SEL)selector;

@end
