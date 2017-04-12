//
//  PWVBLocationManager.h
//  PWLocation
//
//  Created on 10/26/16.
//  Copyright © 2016 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PWLocation/PWLocationManager.h>
#import <PWLocation/PWIndoorLocation.h>

extern NSString * const kMistFloorIdentifierKey;
extern NSString * const kMaasFloorIdentifierKey;
extern NSString * const kFloorUpperLeftKey;
extern NSString * const kFloorLowerRightKey;
extern NSString * const kFloorLatitudeKey;
extern NSString * const kFloorLongitudeKey;

@class PWBPLocationManager, PWMSLocationManager;

@interface PWVBLocationManager : NSObject <PWLocationManager>

/**
 The last indoor location received.
 */
@property (nonatomic, readonly) PWIndoorLocation *location;

/**
 The MIST SDK token, starts with D, S, or P.
 */
@property (nonatomic, readonly) NSString *sdkToken;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface PWBPLocationManager : PWVBLocationManager

/**
 @param sdkToken The Beacon Point SDK token, which starts with D, S, or P.
 @param floorConfigurations array containing dictionaries of floor info. Example for one floor:
 {
     "id" : @"BEACON_POINT_FLOOR_NAME",
     "maasId" : 195842,
 
     "upperLeft" : {
         "longitude" : -97.742525,
         "latitude" : 30.360108
     },
     "lowerRight" : {
         "longitude" : -97.741753,
         "latitude" : 30.359737
     }
 }
 @param completion Block called when PWBPLocationManager has been initialized. Gives the manager object or error if there was one.
 */
+ (void)createBPWithSDKToken:(NSString *)sdkToken floorConfigurations:(NSArray *)floorConfigurations onComplete:(void(^)(PWBPLocationManager *manager, NSError *error))completion;

@end

@interface PWMSLocationManager : PWVBLocationManager

/**
 @param sdkToken The Mist SDK token, which starts with D, S, or P.
 @param floorConfigurations array containing dictionaries of floor info. Example for one floor:
 {
     "id" : @"MIST_FLOOR_NAME",
     "maasId" : 195842,
 
     "upperLeft" : {
         "longitude" : -97.742525,
         "latitude" : 30.360108
     },
     "lowerRight" : {
         "longitude" : -97.741753,
         "latitude" : 30.359737
     }
 }
 @param completion Block called when PWMSLocationManager has been initialized. Gives the manager object or error if there was one.
 */
+ (void)createMSWithSDKToken:(NSString *)sdkToken floorConfigurations:(NSArray *)floorConfigurations onComplete:(void(^)(PWMSLocationManager *manager, NSError *error))completion;

@end
