//
//  PWMapKitAnalytics+Private.h
//  PWMapKit
//
//  Created by Xiangwei Wang on 6/4/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <PWLocation/PWLocation.h>

#import "PWMapKitAnalytics.h"
#import "PWBuilding.h"
#import "PWUserLocation.h"
#import "PWRouteManager.h"
#import "PWPointOfInterest+Private.h"
#import "PWFloor+Private.h"
#import "PWMapView+Private.h"

extern NSString * const PWMapKitMappingTypeName;

extern NSString * const PWAnalyticsTypeBuildingLoaded;
extern NSString * const PWAnalyticsTypePOISearchText;
extern NSString * const PWAnalyticsTypePOISelected;
extern NSString * const PWAnalyticsTypeFloorLoaded;
extern NSString * const PWAnalyticsTypeRouteRequested;
extern NSString * const PWAnalyticsTypeChangedIndoorUserTrackingMode;
extern NSString * const PWAnalyticsTypeRegisteredLocationProvider;
extern NSString * const PWAnalyticsTypeBlueDotAcquisitionTime;

extern NSString * const PWAnalyticsBlueDotAcquisitionTimeKey;

@interface PWMapKitAnalytics()

@property (nonatomic, strong) NSMutableDictionary *analyticsCache;
@property (nonatomic, getter=isAnalyticsEnabled) BOOL analyticsEnabled;
@property (nonatomic) BOOL blueDotAcquired;

@property (nonatomic, copy) void (^completion)(NSError *error);

- (void)startBlueDotAcquisitionTimer;

#pragma mark - Convenience

/**
 Get a singleton object of `PWMapKitAnalytics`.
 @return Return a singleton object of `PWMapKitAnalytics`.
 */
+ (PWMapKitAnalytics *)sharedInstance;

/**
 Get the location provider name by its class.
 @param locationManager The object of location provider.
 @return Return the name of location provider.
 */
- (NSString*)getNameForLocationManager:(id<PWLocationManager>)locationManager;

/**
 Get the user tracking mode name.
 @param mode A enum of PWTrackingMode.
 @return Return the name of user tracking mode.
 */
- (NSString*)getNameForIndoorUserTrackingMode:(PWTrackingMode)mode;

#pragma mark - Sending

/**
 Send analytics to MaaS server.
 @param analyticsPayload The data you want to send.
 */
- (void)sendAnalytics:(NSDictionary*)analyticsPayload;

/**
 Send analytics for blue dot acquisition time to MaaS server.
 @param indoorUserLocation The current indoor location.
 @param building The current building object.
 */
- (void)sendAnalyticsForBlueDotAcquisitionTimeWithLocation:(PWUserLocation*)indoorUserLocation withBuilding:(PWBuilding*)building locationManager:(id<PWLocationManager>)locationManager;

/**
 Send analytics for building loaded to MaaS server.
 @param building The building object.
 */
- (void)sendAnalyticsForBuildingLoaded:(PWBuilding*)building;

/**
 Send analytics for floor loaded to MaaS server.
 @param floor The loaded floor object.
 @param building The building object.
 */
- (void)sendAnalyticsForFloorLoaded:(PWFloor*)floor withBuilding:(PWBuilding*)building;

/**
 Send analytics for POI selected to MaaS server.
 @param point The selected point.
 @param building The building object.
 */
- (void)sendAnalyticsForPointOfInterestSelected:(PWPointOfInterest*)point withBuilding:(PWBuilding*)building;

/**
 Send analytics for route requested to MaaS server.
 @param originPoint The start point.
 @param destinationPoint The destination point.
 @param directionType Check if the route accessible
 @param success If there is available route found
 @param building The building object.
 */
- (void)sendAnalyticsForRouteRequestedFrom:(id<PWMapPoint>)originPoint to:(id<PWMapPoint>)destinationPoint directionType:(PWDirectionsType)directionType success:(BOOL)success withBuilding:(PWBuilding*)building;

/**
 Send analytics for route requested to MaaS server.
 @param startAnnotation The start point.
 @param endAnnotation The destination point.
 @param directionType Check if the route accessible
 @param success If there is available route found
 @param building The building object.
 */
- (void)sendAnalyticsForRouteRequestedFromAnnotation:(id<PWMapPoint>)startAnnotation toAnnotation:(id<PWMapPoint>)endAnnotation directionType:(PWDirectionsType)directionType success:(BOOL)success withBuilding:(PWBuilding*)building;

/**
 Send analytics for changed indoor user tracking mode to MaaS server.
 @param oldTrackingMode The old indoor user tracking mode.
 @param newTrackingMode The new indoor user tracking mode.
 */
- (void)sendAnalyticsForChangedIndoorUserTrackingModeFrom:(PWTrackingMode)oldTrackingMode to:(PWTrackingMode)newTrackingMode building:(PWBuilding *)building;

/**
 Send analytics for registered location provider to MaaS server.
 @param locationManager The location manager object.
 @param building The building object.
 */
- (void)sendAnalyticsForRegisteredLocationProvider:(id<PWLocationManager>)locationManager  withBuilding:(PWBuilding*)building;

@end
