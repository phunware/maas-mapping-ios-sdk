//
//  POIDetailsViewController.h
//  PWMapKit
//
//  Created on 8/10/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@class PWPointOfInterest;
@class PWCustomLocation;

@interface POIDetailsViewController : UIViewController

@property (nonatomic, strong) PWPointOfInterest *pointOfInterest;
@property (nonatomic, strong) PWCustomLocation *userLocation;

@end
