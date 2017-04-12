//
//  PWCore.h
//  PWCore
//  v3.0.3
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWCore/PWCoreVersion.h>
#import <PWCore/MaaSCore.h>
#import <PWCore/MaaSCoreVersion.h>
#import <PWCore/PWBundleManager.h>
#import <PWCore/PWAPIManager.h>

/**
 `PWCore` implements core functionality used in all MaaS modules. All MaaS modules have a `PWCore` dependency.
 */

@interface PWCore : NSObject

///-----------------------
/// @name Required Methods
///-----------------------

/**
 Initializes PWCore and all associated MaaS modules. This method should be called inside `application:didFinishLaunchingWithOptions:` before you do anything else.
 @param applicationID You can find your Application ID in the MaaS portal.
 @param accessKey A unique key that identifies the client making the request. You can find your Access Key in the MaaS portal.
 @param signatureKey A unique key that is used to sign requests. The signature is used to both check request authorization as well as data integrity. You can find your Signature Key in the MaaS portal.
 @param encryptionKey The key used to encrypt and decrypt data that is exchanged between the client and the server. You can find your Encryption Key in the MaaS portal.
 */
+ (void)setApplicationID:(NSString *)applicationID
               accessKey:(NSString *)accessKey
            signatureKey:(NSString *)signatureKey
           encryptionKey:(NSString *)encryptionKey;

///---------------
/// @name Optional
///---------------

/**
 Returns the MaaS Application ID.
 */
+ (NSString *)applicationID;

/**
 Returns the Device ID.
 */
+ (NSString *)deviceID;

/**
 Returns 'MaaSCore'.
 */
+ (NSString *)serviceName;

/**
 Returns if API encription enabled
 */
+ (BOOL)encryptionEnabled;

@end
