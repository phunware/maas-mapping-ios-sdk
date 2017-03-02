//
//  TrackingModeView.h
//  PWLocation
//
//  Created on 1/25/17.
//  Copyright © 2017 Phunware Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingModeView : UIBarButtonItem

- (instancetype)initWithMapView:(PWMapView *)mapView;
- (void)updateButtonStateAnimated:(BOOL)animated;

@end
