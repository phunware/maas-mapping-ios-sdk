//
//  PWAccessibilityProtocol.h
//  PWMapKit
//
//  Created by Sam Odom on 3/20/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The `PWAccessibilityProtocol` defines a protocol to indicating whether or not an object is accessible or not. This is used primarily for objects that conform to `PWAttotationProtocol`.
 */

@protocol PWAccessibilityProtocol <NSObject>

/**
 A flag indicating whether the point represented by the conforming object are accessible. (read-only)
 */
@property (readonly, getter=isAccessible) BOOL accessible;

@end
