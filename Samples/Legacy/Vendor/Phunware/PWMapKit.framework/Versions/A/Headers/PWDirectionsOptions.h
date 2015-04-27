//
//  PWDirectionsOptions.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class represents the various routing options available when requesting directions.
 */
@interface PWDirectionsOptions : NSObject <NSCopying>

/**
 Flag indicating whether the requested directions must include only accessible points.
 @discussion The default value for this option is `false`.
 */
@property BOOL requireAccessibleRoutes;

@end
