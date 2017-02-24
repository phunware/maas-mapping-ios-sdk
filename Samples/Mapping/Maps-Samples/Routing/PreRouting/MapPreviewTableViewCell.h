//
//  MapPreviewTableViewCell.h
//  PWMapKit
//
//  Created on 8/18/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWRoute, PWMapView;

extern NSString * const MapPreviewTableViewCellReuseIdentifier;

@interface MapPreviewTableViewCell : UITableViewCell

- (void)configureForRoute:(PWRoute *)route mapView:(PWMapView *)mapView;

@end
