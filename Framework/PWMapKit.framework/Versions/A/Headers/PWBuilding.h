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
@property (readonly) NSArray *pois;

/**
 *  An array of PWPointOfInterestType objects that are used in MaaS Portal.
 */
@property (readonly) NSArray *pointOfInterestTypes;

/**
 *  The center coordinate of the building.
 */
@property (readonly) CLLocationCoordinate2D coordinate;

/**
 Create `PWBuilding` with provided building identifier.
 @param identifier The building identifier to use for initialization.
 @param completion The block to execute when the building data is completely loaded.
 @discussion It checks the network connectivity before starting to download the building, if it's disconnected, use cached one and returns immediately, otherwise to check if the cached is up to date then decide it's necessary to re-download.
 */
+ (void)buildingWithIdentifier:(NSInteger)identifier completion:(void(^)(PWBuilding *building, NSError *error))completion;

/**
 Create `PWBuilding` with provided building identifier.
 @param identifier The building identifier to use for initialization.
 @param caching YES/NO. Determines if the SDK will use prior cache information to instantiate the building structure. Default YES.
 @param completion The block to execute when the building data is completely loaded.
 @discussion Please change to use `[PWBuilding buildingWithIdentifier:completion:]` instead.
 */
+ (void)buildingWithIdentifier:(NSInteger)identifier usingCache:(BOOL) caching completion:(void(^)(PWBuilding *building, NSError *error))completion __deprecated;

/**
 *  Returns a `PWFloor` instance that has the given floor identifier.
 *  @param identifier The identifier of the floor.
 *  @return Returns a `PWFloor` instance that has the given identifier.
 *  @discussion Please change to use `floorById:` instead.
 */
- (PWFloor *)getFloorByFloorId:(NSInteger)identifier __deprecated;

/**
 *  Returns a `PWFloor` instance that has the given floor identifier.
 *  @param identifier The identifier of the floor.
 *  @return Returns a `PWFloor` instance that has the given identifier.
 */
- (PWFloor *)floorById:(NSInteger)identifier;

/**
 *  Returns a PWPointOfInterest instance that has the given identifier.
 *  @param identifier The MaaS portal identifier of the point-of-interest.
 *  @return Returns a PWPointOfInterest instance that has the given identifier.
 */
- (PWPointOfInterest *)pointOfInterestById:(NSInteger)identifier;

/**
 *  Finds the closest point-of-interest to the custom location.
 *  @param location A PWCustomLocation reference.
 *  @return Returns a PWPointOfInterest object.
 */
- (PWPointOfInterest *)pointOfInterestClosestToLocation:(id<PWMapPoint>)location;

/**
 *  Determines if the coordinate is contained within the latitude and longitude bounds of the building.
 *  @param coordinate A CLLocationCoordinate2D reference.
 *  @return Returns a BOOL value YES/NO.
 */
- (BOOL)containsCoordinate:(CLLocationCoordinate2D)coordinate;

@end
