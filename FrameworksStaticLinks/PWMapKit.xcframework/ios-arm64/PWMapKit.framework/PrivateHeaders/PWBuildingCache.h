//
//  PWBuildingCache.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 06/02/2017.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWBuildingCache : NSObject


/**
 Get building data from cache or download from remote if it's cached yet.
 @param url The content URL
 @param completion A block indicates if the data fetching is done
 */
+ (void)cacheDataWithURL:(NSURL *)url completion:(void(^)(NSData *data, NSError *error))completion;

/**
 Force to update the data for the URL
 @param url The content URL
 @param completion A block indicates if the data fetching is done
 */
+ (void)updateDataWithURL:(NSURL *)url completion:(void(^)(NSData *data, NSError *error))completion;

/**
 Remove building data
 */
+ (void)removeData;

@end
