//
//  PWFloor.h
//  PWMapKit
//
//  Created by Steven Spry on 5/12/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "PWPointOfInterestType.h"
#import "PWBuilding.h"

@class PWBuilding;

/**
 *  A PWFloor represents a building's floor structure defined within MaaS Portal.
 */
@interface PWFloor : NSObject

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  A reference to the floor's building object.
 */
@property (nonatomic,readonly,weak) PWBuilding *building;

/**
 *  The name of the floor as defined in MaaS Portal.
 */
@property (nonatomic,copy,readonly) NSString *name;

/**
 *  The floor's identifier.
 */
@property (nonatomic,readonly) NSInteger floorID;

/**
 *  The floor's level number.
 */
@property (nonatomic,readonly) NSInteger level;

/**
 *  An array of PWPointOfInterestType objects that belong to the floor.
 */
@property (nonatomic,readonly) NSMutableArray *pointsOfInterest;

/**
 *  The top-left coordinate (latitude and longitude) of the floor.
 */
@property (nonatomic,readonly) CLLocationCoordinate2D topLeft;

/**
 *  The bottom-right coordinate (latitude and longitude) of the floor.
 */
@property (nonatomic,readonly) CLLocationCoordinate2D bottomRight;

/**---------------------------------------------------------------------------------------
 * @name Instance Methods
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Determines if a given coordinate is contained within the floor's bounding latitude and longitude.
 *
 *  @param coordinate A CLLocationCoordinate2D object containing latitude and longitude.
 *
 *  @return Returns a BOOL value saying if the floor contains the given coordinate.
 */
- (BOOL) containsCoordinate:(CLLocationCoordinate2D) coordinate;

/**
 *  Returns an array containing the floor's points of interest of the specified point of interest type.
 *
 *  @param type A PWPointOfInterestType.
 *
 *  @return Returns NSArray containing a list of PWPointOfInterestType objects for the given type.
 */
- (NSArray *) pointsOfInterestOfType:(PWPointOfInterestType *) type;

/**
 *  Returns an array containing the floor's points of interest of the specified point of interest type and whose name contains the supplied text.
 *
 *  @param type           A PWPointOfInterestType.
 *  @param containingText A NSString substring of text to search for.
 *
 *  @return Returns NSArray containing a list of PWPointOfInterestType objects for the given type and whose name contains the supplied text.
 */
- (NSArray *) pointsOfInterestOfType:(PWPointOfInterestType *) type containing:(NSString *) containingText;


@end
