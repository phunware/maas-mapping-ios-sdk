//
//  PWMapDataLoader.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 11/16/15.
//  Copyright © 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWBuilding.h"
#import "PWMappingTypes.h"

/**
 The class for pre-load map data
 */
@interface PWMapDataLoader : NSObject

/**
 Building load completion block
 `building` Loaded building info
 `error` Error message if it's failed to load the building
 */
@property (copy) void (^preloadBuildingCompletionBlock)(PWBuilding *building, NSError *error);

/**
 Pre-load build for specific building identifier
 @param buildingID The building identifier you want to load
 */
- (void)loadWithBuildingID:(PWBuildingIdentifier)buildingID;

@end
