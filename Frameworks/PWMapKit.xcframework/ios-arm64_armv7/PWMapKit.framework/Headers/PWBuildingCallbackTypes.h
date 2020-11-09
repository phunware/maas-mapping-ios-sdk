//
//  PWBuildingCallbackTypes.h
//  PWMapKit
//
//  Created by Aaron Pendley on 3/12/20.
//  Copyright © 2020 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWBuilding;
@class PWPointOfInterestInfo;

typedef void(^PWFetchFloorCompletionBlock)(NSError* _Nullable error);

typedef void(^PWLoadBuildingCompletionBlock)(PWBuilding* _Nullable building , NSError* _Nullable error);

typedef void(^PWPointOfInterestImageLoadingCompleted)(UIImage* _Nullable image, NSError* _Nullable error);

typedef void(^PWSetCustomImageForPointOfInterest)(UIImage* _Nullable  image);
typedef void(^PWLoadCustomImageForPointOfInterest)(PWPointOfInterestInfo* _Nonnull poiInfo, PWSetCustomImageForPointOfInterest _Nonnull setImage);
