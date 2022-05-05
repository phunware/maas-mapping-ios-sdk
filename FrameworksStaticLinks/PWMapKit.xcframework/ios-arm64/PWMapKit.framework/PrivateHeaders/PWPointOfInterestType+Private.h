//
//  PWPointOfInterestType+Private.h
//  PWMapKit
//
//  Created by Illya Busigin on 10/23/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWPointOfInterestType.h"
#import "PWPointOfInterestImageLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWPointOfInterestType ()

@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSString *name;
@property (nonatomic) NSURL *iconURL;
@property (nonatomic, nullable) PWPointOfInterestImageLoader* imageLoader;
@property (nonatomic, readonly) BOOL isLoadingImage;
@property (nonatomic, readonly, nullable) UIImage *image;

- (void)loadImageWithURL:(NSURL *)url
             forceUpdate:(BOOL)forceUpdate;

- (void)notifyWhenImageLoaded:(PWPointOfInterestImageLoadingCompleted)callback;


- (instancetype)initWithIdentifier:(NSInteger)identifier name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
