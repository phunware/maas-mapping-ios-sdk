//
//  PWRouteOptions.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 5/6/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class represents the various routing options available when requesting directions.
 */
@interface PWRouteOptions : NSObject

/**
 * Default initializer. All options are initailized to their default values.
 */
-(instancetype _Nonnull)init;

/**
 * Designated initializer.
 */
-(instancetype _Nonnull)initWithAccessibilityEnabled:(BOOL)accessibilityEnabled
                                     landmarksEnabled:(BOOL)landmarksEnabled
                             excludedPointIdentifiers:(NSArray<NSNumber *> * _Nullable)excludedPointIdentifiers NS_DESIGNATED_INITIALIZER;

/**
 Flag indicating whether the requested directions must include only accessible points.
 @discussion The default value for this option is `false`.
 */
@property(nonatomic, assign) BOOL accessibilityEnabled;

/**
 * Flag indicating whether landmarks should be generated for maneuvers/route instructions
 * @discussion The default value for this option is `false`.
 */
@property(nonatomic, assign) BOOL landmarksEnabled;

/**
 An array of excluded point identifiers that you do not want to be used when calculating directions.
 @discussion The array contents must only be `NSNumber` values.
 */
@property (nonatomic, retain, nullable) NSArray<NSNumber *> *excludedPointIdentifiers;

@end
