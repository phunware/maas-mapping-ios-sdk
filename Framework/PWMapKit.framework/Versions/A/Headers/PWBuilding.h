//
//  PWBuilding.h
//  PWMapKit
//
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class PWFloor;
@class PWPointOfInterest;
@class PWCustomLocation;

/**
 *  A PWBuilding represents the building structure defined within MaaS Portal.
 */
@interface PWBuilding : NSObject

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  The identifier for the building structure that corresponds to the MaaS Portal.
 */
@property (nonatomic, readonly) NSInteger identifier;

/**
 *  The name of the building as defined in MaaS Portal.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *  An array of PWFloor objects that are contained in the building.
 */
@property (nonatomic, readonly) NSMutableArray *floors;

/**
 *  An array of PWPointOfInterestType objects that are used in MaaS Portal.
 */
@property (nonatomic, readonly) NSMutableArray *pointOfInterestTypes;

/**
 *  The center point latitude and longitude of the building.
 */
@property (nonatomic) CLLocationCoordinate2D coordinate;

/**---------------------------------------------------------------------------------------
 * @name Class Methods
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Instantiates a new building structure using the MaaS Portal identifier. The completion handler is called when the building structure is fully loaded, including any network access.
 *
 *  @param identifier The identifier used in MaaS Portal for the building.
 *  @param caching    YES/NO. Determines if the SDK will use prior cache information to instantiate the building structure. Default YES.
 *  @param completion Completion handler that is called once building load is complete.
 *  @param discussion Please change to use `[PWBuilding buildingWithIdentifier:completion:]` instead.
 */
+ (void)buildingWithIdentifier:(NSInteger)identifier usingCache:(BOOL) caching completion:(void(^)(PWBuilding *building, NSError *error))completion __deprecated;

/**
 *  Instantiates a new building structure using the MaaS Portal identifier. The completion handler is called when the building structure is fully loaded.
 *
 *  @param identifier The identifier used in MaaS Portal for the building.
 *  @param completion Completion handler that is called once building load is complete.
 */
+ (void)buildingWithIdentifier:(NSInteger)identifier completion:(void(^)(PWBuilding *building, NSError *error))completion;

/**---------------------------------------------------------------------------------------
 * @name Instance Methods
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Returns a PWBuilding instance for the given buildingId.
 *
 *  @param buildingId The identifier used in MaaS Portal for the building.
 *
 *  @return Returns a PWBuilding instance for the given buildingId.
 */
- (instancetype) initWithBuildingId:(NSInteger)buildingId;

/**
 *  Allows the SDK developer to "override" point of interest types with an alternate title and image.
 *
 *  @param identifier Point of Interest Identifier defined in MaaS Portal.
 *  @param title      The title to be used.
 *  @param image      The image to be used.
 */
- (void) registerPointOfInterestType:(NSInteger) identifier title:(NSString *) title image:(UIImage *) image;

/**
 *  Returns a PWPointOfInterest instance that has the given identifier.
 *
 *  @param identifier The MaaS portal identifier of the point of interest.
 *
 *  @return Returns a PWPointOfInterest instance that has the given identifier.
 */
- (PWPointOfInterest *) pointOfInterestById:(NSInteger) identifier;

/**
 *  Determines if the coordinate is contained within the latitude and longitude bounds of the building.
 *
 *  @param coordinate A CLLocationCoordinate2D reference.
 *
 *  @return Returns a BOOL value YES/NO.
 */
- (BOOL) containsCoordinate:(CLLocationCoordinate2D) coordinate;

/**
 *  Finds the closest point of interest to the custom location.
 *
 *  @param location A PWCustomLocation reference.
 *
 *  @return Returns a PWPointOfInterest object.
 */
- (PWPointOfInterest *) pointOfInterestClosestToLocation:(PWCustomLocation *)location;

/**
 *  Returns a `PWFloor` instance that has the given floor identifier.
 *
 *  @param identifier The identifier of the floor.
 *
 *  @return Returns a `PWFloor` instance that has the given identifier.
 */
- (PWFloor *) getFloorByFloorId:(NSInteger)floorId;

@end
