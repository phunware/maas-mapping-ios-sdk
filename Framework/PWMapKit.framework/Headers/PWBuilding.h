//
//  PWBuilding.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <CoreLocation/CLLocation.h>

@protocol PWMapPoint;
@class PWFloor;
@class PWPointOfInterest;
@class PWPointOfInterestType;

/**
 The building object encompasses a wide variety of information associated with the building. Information includes but is not limited to: floor data, floor resource data, street address and location.
 */
@interface PWBuilding : NSObject

/**
 *  The identifier for the building structure that corresponds to the MaaS Portal.
 */
@property (readonly) NSInteger identifier;

/**
 *  The name of the building as defined in MaaS Portal.
 */
@property (readonly) NSString *name;

/**
 *  An array of `PWFloor` objects that are contained in the building.
 */
@property (readonly) NSArray *floors;

/**
 *  An array of `PWPointOfInterest` objects that are contained in the building.
 */
@property (readonly) NSArray<PWPointOfInterest *> *pois;

/**
 *  An array of `PWPointOfInterestType` objects that are used in MaaS Portal.
 */
@property (readonly) NSArray<PWPointOfInterestType *> *pointOfInterestTypes;

/**
 *  The center coordinate of the building.
 */
@property (readonly) CLLocationCoordinate2D coordinate;

/**
 *  Extra information about the `PWBuilding` object and the data it consumes.
 */
@property (readonly) NSDictionary *userInfo;

/**
 Create `PWBuilding` with provided building identifier.
 @param identifier The building identifier to use for initialization.
 @param completion The block to execute when the building data is completely loaded.
 @discussion It checks the network connectivity before starting to download the building: if it's disconnected, use cached one and return immediately, otherwise check if the cached bulding is up to date then decide if it's necessary to re-download.
 */
+ (void)buildingWithIdentifier:(NSInteger)identifier completion:(void(^)(PWBuilding *building, NSError *error))completion;

/**
 Create `PWBuilding` with provided building identifier.
 @param identifier The building identifier to use for initialization.
 @param cacheFallbackTimeout The timeout for network request to get the building before falling back to the cached version. This is only used if a cached building exists. For non-cached buildings this is not honored.
 @param completion The block to execute when the building data is completely loaded.
 @discussion It checks the network connectivity before starting to download the building: if it's disconnected, use cached one and return immediately, otherwise check if the cached building is up to date then decide if it's necessary to re-download if it completes within the fallback timeout. Otherwise will return the cached building.
 */
+ (void)buildingWithIdentifier:(NSInteger)identifier cacheFallbackTimeout:(NSTimeInterval)cacheFallbackTimeout completion:(void(^)(PWBuilding *building, NSError *error))completion;

/**
 * Create `PWBuilding` with provided building identifier.
 * @param identifier The building identifier to use for initialization.
 * @param caching YES/NO. Determines if the SDK will use prior cache information to instantiate the building structure. Default YES.
 * @param completion The block to execute when the building data is completely loaded.
 *
 * @deprecated Use `buildingWithIdentifier:completion:` instead, since v3.2.0
 */
+ (void)buildingWithIdentifier:(NSInteger)identifier usingCache:(BOOL)caching completion:(void(^)(PWBuilding *building, NSError *error))completion __deprecated;

/**
 * Returns a `PWFloor` instance that has the given floor identifier.
 * @param identifier The identifier of the floor.
 * @return Returns a `PWFloor` instance that has the given identifier.
 *
 * @deprecated Use `floorById:` instead, since v3.2.0
 */
- (PWFloor *)getFloorByFloorId:(NSInteger)identifier __deprecated;

/**
 * Returns a `PWFloor` instance that has the given floor identifier.
 * @param identifier The identifier of the floor.
 * @return Returns a `PWFloor` instance that has the given identifier.
 */
- (PWFloor *)floorById:(NSInteger)identifier;

/**
 * Returns a `PWPointOfInterest` instance that has the given identifier.
 * @param identifier The MaaS portal identifier of the point-of-interest.
 * @return Returns a `PWPointOfInterest` instance that has the given identifier.
 */
- (PWPointOfInterest *)pointOfInterestById:(NSInteger)identifier;

/**
 * Finds the closest point-of-interest to the `PWMapPoint` object's location.
 * @param location A `PWMapPoint` reference.
 * @return Returns a `PWPointOfInterest` object.
 */
- (PWPointOfInterest *)pointOfInterestClosestToLocation:(id<PWMapPoint>)location;

/**
 * Determines if the coordinate is contained within the latitude and longitude bounds of the building.
 * @param coordinate A `CLLocationCoordinate2D` reference.
 * @return Returns a BOOL value YES/NO.
 */
- (BOOL)containsCoordinate:(CLLocationCoordinate2D)coordinate;

@end
