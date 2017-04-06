//
//  POICategoryViewController.h
//  Maps-Samples
//
//  Created by Chesley Stephens on 4/5/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol POITypeViewControllerDelegate <NSObject>

- (void)didSelectPOIType:(PWPointOfInterestType *)poiType;

@end

@interface POITypeViewController : UITableViewController

@property (nonatomic, weak) id <POITypeViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *poiTypes;
@property (nonatomic, strong) PWPointOfInterestType *selectedPoiType;

@end
