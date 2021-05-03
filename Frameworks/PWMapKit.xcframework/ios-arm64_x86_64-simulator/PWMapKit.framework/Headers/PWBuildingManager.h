//
//  PWBuildingManager.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 02/02/2017.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWBuilding.h"

@interface PWBuildingManager : NSObject

// If this property is set by the application, the building manager will use this block to load images for each
// point of interest annotation when loading a building. If this property is NULL (default), these images
// will be downloaded from the network based on their poi type instead.
@property (class, nonatomic, copy) PWLoadCustomImageForPointOfInterest customImageLoaderForPointsOfInterest;

+ (void)buildingWithBuildingId:(NSInteger)buildingId
          cacheFallbackTimeout:(NSTimeInterval)cacheFallbackTimeout
   usePreviouslyLoadedBuilding:(BOOL)usePreviouslyLoadedBuilding
                    completion:(PWLoadBuildingCompletionBlock)completion;

+ (void)fetchPDFForFloor:(PWFloor*)floor
              withOption:(BOOL)forceUpdate
         bundleDirectory:(NSString *)bundleDirectory
              buildingId:(NSInteger)buildingId
              completion:(PWFetchFloorCompletionBlock)completion;

+ (void) buildingWithBuildingId:(NSInteger)buildingId
                bundleDirectory:(NSString *)bundleDirectory
                     completion:(PWLoadBuildingCompletionBlock)completion;

@end
