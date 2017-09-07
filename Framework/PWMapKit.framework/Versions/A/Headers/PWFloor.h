//
//  PWMapFloor.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <CoreLocation/CLLocation.h>

@class PWPointOfInterestType;
@class PWBuilding;

/**
 * The building floor object encapsulates all data related to a floor.
 */
@interface PWFloor : NSObject

/**
 *  A reference to the floor's building object.
 */
@property (readonly, weak) PWBuilding *building;

/**
 *  The floor's identifier.
 */
@property (readonly) NSInteger floorID;

/**
 *  The name of the floor as defined in MaaS Portal.
 */
@property (readonly) NSString *name;

/**
 *  The floor's level number.
 */
@property (readonly) NSInteger level;

/**
 *  An array of PWPointOfInterestType objects that belong to the floor.
 */
@property (readonly) NSArray *pointsOfInterest;

/**
 *  The top-left coordinate (latitude and longitude) of the floor.
 */
@property (readonly) CLLocationCoordinate2D topLeft;

/**
 *  The bottom-right coordinate (latitude and longitude) of the floor.
 */
@property (readonly) CLLocationCoordinate2D bottomRight;

/**
 *  Determines if a given coordinate is contained within the floor's bounding latitude and longitude.
 *  @param coordinate A CLLocationCoordinate2D object containing latitude and longitude.
 *  @return Returns a BOOL value saying if the floor contains the given coordinate.
 */
- (BOOL)containsCoordinate:(CLLocationCoordinate2D) coordinate;

/**
 *  Returns an array containing the floor's points of interest of the specified point-of-interest type.
 *  @param type A PWPointOfInterestType.
 *  @return Returns NSArray containing a list of PWPointOfInterestType objects for the given type.
 */
- (NSArray *)pointsOfInterestOfType:(PWPointOfInterestType *)type;

/**
 *  Returns an array containing the floor's points of interest of the specified point-of-interest type and whose name contains the supplied text.
 *  @param type A PWPointOfInterestType.
 *  @param containingText A NSString substring of text to search for.
 *  @return Returns NSArray containing a list of PWPointOfInterestType objects for the given type and whose name contains the supplied text.
 */
- (NSArray *)pointsOfInterestOfType:(PWPointOfInterestType *)type containing:(NSString *)containingText;

@end
