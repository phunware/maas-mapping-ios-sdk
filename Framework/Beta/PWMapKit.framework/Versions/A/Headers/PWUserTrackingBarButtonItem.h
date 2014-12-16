//
//  PWUserTrackingBarButtonItem.h
//  PWMapKit
//
//  Created by Illya Busigin on 5/5/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWMapView;

/**
 A PWUserTrackingBarButtonItem object is a specialized bar button item that allows the user to toggle through the indoor user tracking modes. For example, when the user taps the button, the map view toggles between tracking the user with and without heading. The button also reflects the current user tracking mode if set elsewhere. This bar button item is associated with a single indoor map view.
 
It's important to note that `MKUserTrackingMode` and `PWIndoorUserTrackingMode` are mutually exclusive. Enabling `MWUserTrackingModeFollow` and `MKUserTrackingModeFolloWWithHeading` will disable indoorUserTrackingMode by setting the property to `PWIndoorUserTrackindModeNone`.
 */

@interface PWUserTrackingBarButtonItem : UIBarButtonItem

/**
 The map view associated with this bar button item.
 */
@property (nonatomic, strong) PWMapView *mapView;

/**
 The tint color of the map bar button items.
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 Initializes a newly created bar button item with the specified indoor map view.
 @param mapView The indoor map view used by this bar button item.
 @return The initialized bar button item.
 */
- (instancetype)initWithMapView:(PWMapView *)mapView;

@end
