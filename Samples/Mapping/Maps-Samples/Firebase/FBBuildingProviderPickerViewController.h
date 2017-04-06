//
//  PWBuildingTypePickerViewController.h
//  PWLocation
//
//  Created by Chesley Stephens on 2/27/17.
//  Copyright © 2017 Phunware Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBBuilding;

@protocol FBBuildingProviderPickerDelegate <NSObject>

- (void)didSelectProvider;

@end

@interface FBBuildingProviderPickerViewController : UITableViewController

@property (nonatomic, strong) FBBuilding *selectedBuilding;
@property (nonatomic, weak) id <FBBuildingProviderPickerDelegate> delegate;

@end
