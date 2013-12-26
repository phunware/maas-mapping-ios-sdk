//
//  PWRoute.h
//  PWMapKit
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `PWRoute` encapsulates all data related to a route between two points.
 */

@interface PWRoute : NSObject

/**
 The name of the route.
 */
@property (nonatomic, strong) NSString *name;

/**
 The origin annotation ID.
 */
@property (nonatomic, readonly) NSInteger startAnnotationID;

/**
 The destination annotation ID.
 */
@property (nonatomic, readonly) NSInteger endAnnotationID;

/**
 A boolean value that indicates whether or not the `PWRoute` object is accessible.
 */
@property (nonatomic, readonly) BOOL isAccessible;

/**
 The segments that make up the `PWRoute`.
 */
@property (nonatomic, readonly) NSArray *segments;

@end
