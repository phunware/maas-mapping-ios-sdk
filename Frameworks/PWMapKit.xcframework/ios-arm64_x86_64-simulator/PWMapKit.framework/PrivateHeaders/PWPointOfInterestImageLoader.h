//
//  PWPointOfInterestImageLoader.h
//  AFNetworking
//
//  Created by Aaron Pendley on 3/17/20.
//

#import <Foundation/Foundation.h>
#import "PWBuildingCallbackTypes.h"
#import "PWPointOfInterestInfo.h"
#import "EXTScope.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWPointOfInterestImageLoader : NSObject

@property (nonatomic, nullable) NSURL *imageURL;
@property (nonatomic, nullable) UIImage *image;
@property (nonatomic) BOOL isLoading;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (void)loadImageWithURL:(NSURL*)url
      buildingIdentifier:(NSInteger)buildingIdentifier
             forceUpdate:(BOOL)forceUpdate;

- (void)loadImageWithCustomImageLoader:(PWLoadCustomImageForPointOfInterest)customImageLoader
                   pointOfInterestInfo:(PWPointOfInterestInfo*)poiInfo
                        fallbackImageURL:(NSURL*)url
              fallbackBuildingIdentifier:(NSInteger)buildingIdentifier
                forceFallbackImageUpdate:(BOOL)forceUpdate;

- (void)notifyWhenLoaded:(PWPointOfInterestImageLoadingCompleted _Nonnull)callback;

@end

NS_ASSUME_NONNULL_END

