//
//  PWBundleManager.m
//  Azul
//
//  Created by Xiangwei Wang on 07/11/2016.
//  Copyright © 2016 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A generic class for download/decrypt/unzip a bundle for specific URL.
 */
@interface PWBundleManager : NSObject

/**
 Shared `PWBundleManager`.
 */
+ (PWBundleManager *)sharedInstance;

/**
 Remove the bundle for a specific url.
 @param url The specific url for which you want to remove.
 */
- (void)removeBundleForURL:(NSURL *)url;

/**
 Fetch an unencrypted bundle from the url, unpack it, and save the necessary JSON files
 @param url The url that the manager should load.
 @param completion A block that returns the unzipped bundle directory or error.
 */
- (void)fetchBundleWithURL:(NSURL *)url completion:(void(^)(NSString *bundleDirectory, BOOL bundleChanged, NSError *error))completion;

/**
 Fetch an encrypted bundle from the url, decprypt then unpack it, and save the necessary JSON files
 @param url The url that the manager should load.
 @param decryptionKey The key used to deprypt the bundle.
 @param completion A block that returns the unzipped bundle directory or error.
 */
- (void)fetchBundleWithURL:(NSURL *)url decryptionKey:(NSString *)decryptionKey completion:(void(^)(NSString *bundleDirectory, BOOL bundleChanged, NSError *error))completion;

@end
