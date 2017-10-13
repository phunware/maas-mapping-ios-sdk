//
//  PWPointOfInterestType.h
//  PWMapKit
//
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A PWPointOfInterestType represents single point of interest type defined within MaaS Portal.
 */
@interface PWPointOfInterestType : NSObject

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  The identifier for the point of interest type that corresponds to the MaaS Portal.
 */
@property (nonatomic, readonly) NSInteger identifier;

/**
 *  The name of the point of interest type as defined in MaaS Portal.
 */
@property (nonatomic, readonly) NSString *name;

/**
 *  The representative UIImage of the point of interest type.
 */
@property (nonatomic, readonly) UIImage *image;

@end
