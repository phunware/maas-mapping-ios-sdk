//
//  PWPointOfInterestType.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

/**
 An object encompasses a variety of information associated with point-of-interest type.
 */
@interface PWPointOfInterestType : NSObject

/**
 The point-of-interest type identifier.
 */
@property (nonatomic, readonly) NSInteger identifier;

/**
 The point-of-interest name.
 */
@property (nonatomic, readonly) NSString *name;

/**
 The point-of-interest icon image, it's deprecated and you should use `iconURL` property to create an image object instead.
 */
@property (nonatomic, readonly) UIImage *image __deprecated;

/**
 The point-of-interest icon URL.
 */
@property (nonatomic, readonly) NSURL *iconURL;

@end
