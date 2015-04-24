//
//  MaaSCore.h
//  MaaSCore
//
//  Copyright (c) 2013 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 The MaaSLogLevel specifies the level of logging the interal logging will write to the console.
 */
typedef NS_ENUM(NSInteger, MaaSLogLevel)
{
    /** Undefined logging level.
     */
    MaaSLogLevel_Undefined = -1, // Test
    
    /** Specifies all logging as disabled. This is the default logging level.
     */
    MaaSLogLevel_None, // Test
    
    /** Only log errors.
     */
    MaaSLogLevel_Error, // Test
    
    /** Log warnings and all previous logging levels.
     */
    MaaSLogLevel_Warning,
    
    /** Log information and all previous logging levels.
     */
    MaaSLogLevel_Info,
    
    /** Log debug and all previous logging levels.
     */
    MaaSLogLevel_Debug
};

/**
 `MaaSCore` implements core functionality used in all MaaS modules. All MaaS modules have a `MaaSCore` dependency.
 */

@interface MaaSCore : NSObject

///-----------------------
/// @name Required Methods
///-----------------------

/**
 Initializes MaaSCore and all associated MaaS modules. This method should be called inside `application:didFinishLaunchingWithOptions:` before you do anything else.
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
 Set the console logging level for the specified MaaS module. By default, the logging level for all modules is `MaaSLogLevel_None`.

 @param loggingLevel The logging level desired.
 @param serviceName The service name. Every MaaS module has a static `serviceName` method.
 */

+ (void)setLoggingLevel:(MaaSLogLevel)loggingLevel forService:(NSString *)serviceName;

/**
 Disables MaaSCore location services. Location services are used for comprehensive analytics. If you include `CoreLocation.framework` in your project, MaaSCore will automatically request access to the user's current location.
 */
+ (void)disableLocationServices;

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
