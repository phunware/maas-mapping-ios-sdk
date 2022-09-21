//
//  PWPointOfInterest+Private.h
//  PWMapKit
//
//  Created by Illya Busigin on 8/7/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>

#import "PWPointOfInterestType+Private.h"
#import "PWMappingUtilities.h"
#import "PWBuildingCallbackTypes.h"

@class PWPointOfInterestImageLoader;

@interface PWPointOfInterest ()

// Campus info
@property (nonatomic) NSInteger campusID;

// Building info
@property (nonatomic) NSInteger buildingID;

// Floor info
@property (nonatomic) NSInteger floorID;
@property (nonatomic, weak, nullable) PWFloor *floor;
@property (nonatomic) NSInteger level;

// POI
@property (nonatomic) NSInteger identifier;
@property (nonatomic, nullable) NSString *portalID;
@property (nonatomic) NSInteger type;
@property (nonatomic, nullable) PWPointOfInterestType *pointOfInterestType;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, nullable) NSString *summary;
@property (nonatomic, nullable) NSDictionary<NSString *, id> *metaData;
@property (nonatomic) PWMapPointSource source;
@property (nonatomic, getter=isOcclusionEnabled) BOOL occlusionEnabled;
@property (nonatomic, nullable) NSString *category;

// POI - accessible
@property (nonatomic) BOOL visualImpaired;
@property (nonatomic) BOOL accessible;
@property (nonatomic) BOOL exit;
@property (nonatomic) BOOL active;

// POI - zoom
@property (nonatomic) NSInteger minZoomLevel;
@property (nonatomic) NSInteger maxZoomLevel;

// POI - image
@property (nonatomic, nullable) PWPointOfInterestImageLoader* imageLoader;
@property (nonatomic, readonly) BOOL isLoadingImage;

- (BOOL)isPortal;

- (BOOL)isBuildingToBuildingPortal;

- (NSError* _Nullable)validate;

- (void)loadImageWithURL:(NSURL* _Nonnull)url
             forceUpdate:(BOOL)forceUpdate;

- (void)loadImageWithCustomImageLoader:(PWLoadCustomImageForPointOfInterest _Nonnull)loadCustomImage
                      fallbackImageURL:(NSURL* _Nonnull)fallbackImageURL
              forceFallbackImageUpdate:(BOOL)forceFallbackImageUpdate;

- (void)notifyWhenImageLoaded:(PWPointOfInterestImageLoadingCompleted _Nonnull)callback;

@end
