//
//  PWUserTrackingBarButtonItem.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWMapView;

/**
 A PWUserTrackingBarButtonItem object is a specialized bar button item that allows the user to toggle through the indoor user tracking modes. For example, when the user taps the button, the map view toggles between tracking the user with and without heading. The button also reflects the current user tracking mode if set elsewhere. This bar button item is associated with a single indoor map view.
 */

@interface PWUserTrackingBarButtonItem : UIBarButtonItem

/**
 The map view associated with this bar button item.
 */
@property (nonatomic, weak) PWMapView *mapView;

/**
 Initializes a newly created bar button item with the specified indoor map view.
 @param mapView The indoor map view used by this bar button item.
 @return The initialized bar button item.
 */
- (instancetype)initWithMapView:(PWMapView *)mapView;

@end
