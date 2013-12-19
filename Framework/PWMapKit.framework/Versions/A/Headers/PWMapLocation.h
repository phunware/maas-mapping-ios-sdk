//
//  PWMapLocation.h
//  PWMapKit
//
//  Created by Illya Busigin on 12/9/13.
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
`PWMapLocation` encapsulates a location on an indoor map.
*/

@interface PWMapLocation : NSObject <NSCoding, NSCopying>

/**
 The `CGPoint` location in the map coordinate space.
 */
@property (nonatomic, assign) CGPoint location;

/**
 The floor ID for the `PWMapLocation` object.
 */
@property (nonatomic, assign) NSInteger floorID;

@end
