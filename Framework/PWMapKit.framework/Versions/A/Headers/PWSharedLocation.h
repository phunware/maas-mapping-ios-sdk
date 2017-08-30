//
//  PWSharedLocation.h
//  LocationDiagnostic
//
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWLocation/PWLocation.h>

/**
 *  A PWSharedLocation represents a shared location.
 */
@interface PWSharedLocation : NSObject

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
*  The building identifier.
*/
@property (nonatomic, strong, readonly) NSNumber *buildingId;

/**
 *  The floor identifier.
 */
@property (nonatomic, strong, readonly) NSNumber *floorId;

/**
 *  The device identifier.
 */
@property (nonatomic, strong, readonly) NSString *deviceId;

/**
 *  The source of where the shared location is coming from.
 */
@property (nonatomic, strong, readonly) NSString *source;

/**
 *  The display name of the shared location.
 */
@property (nonatomic, strong, readonly) NSString *displayName;

/**
 *  The current location of the shared location.
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D location;

/**
 *  The accuracy of the shared location.
 */
@property (nonatomic, strong, readonly) NSNumber *confidenceFactor;

/**
 *  The user type of the shared location.
 */
@property (nonatomic, strong, readonly) NSString *userType;

- (instancetype)init __unavailable;

@end
