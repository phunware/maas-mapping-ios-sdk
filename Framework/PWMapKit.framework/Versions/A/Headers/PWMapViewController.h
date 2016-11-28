//
//  PWMapViewController.h
//  PWMapKit
//
//  Created by Steven Spry on 5/12/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PWBuilding.h"
#import "PWMapview.h"
#import "PWPointOfInterest.h"
#import "PWBuildingViewController.h"
#import "PWRouteInstruction.h"

/**
 *  Image name to use for the directions/routing bar button item.   This image is supplied in the MNW_Images.xcassets file.  You may change this image.
 */
static NSString *const kPWDirectionBarButtonItemImage = @"PWDirectionBarButtonItemImage";

/**
 *  Image name to use for the change floor bar button item.   This image is supplied in the MNW_Images.xcassets file.  You may change this image.
 */
static NSString *const kPWFloorBarButtonItemImage = @"PWFloorBarButtonItemImage";

/**
 *  The PWMapViewController class provides a "canned," full-featured view controller for displaying and navigating a building.  It is intended to simplify and minimize the effort to incorporate mapping functionality in as few steps as possible. SDK users wishing to further customize mapping capabilities should use MPMapView.
 */
@interface PWMapViewController : UIViewController

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Reference to embedded Map View.
 */
@property (nonatomic, readonly) PWMapView *mapView;

/**---------------------------------------------------------------------------------------
 * @name Instance Methods
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Initializes a new Map View Controller with a PWBuilding Object
 *
 *  @param building A PWBuilding instance representing a building structure.
 *
 *  @return Returns a PWMapViewController object for the given building.
 */
- (instancetype) initWithBuilding:(PWBuilding *)building;

/**
 *  Positions the map to the supplied point of interest. The current floor will be changed as appropriate, and the POI's annotation will be shown.
 *
 *  @param poi A PWPointOfInterest object representing any point of interest inside the building where the map should navigate to.
 */
- (void) navigateToPointOfInterest:(PWPointOfInterest *) poi;

/**
 *  Starts a navigation on the building with a previously initialized PWRoute object. Displays navigation instructions on the PWMapViewController's map.
 *
 *  @param route A PWRoute object representing a route to navigate on the building.
 */
- (void) navigateWithRoute:(PWRoute *)route;

/**
 *  Sets and dislays the current navitation instruction/steps during a navigation.
 *
 *  @param instruction A route instruction object for the route.
 */
- (void) setRouteManeuver:(PWRouteInstruction *)instruction;

/**
 *  Positions the map to the supplied center coordinate with the given zoom level and optional animation.
 *
 *  @param centerCoordinate A CLLocationCoordinate2D object representing the latitude an longitude the map should zoom to.
 *  @param zoomLevel        A NSUInteger value representing zoom level the map should zoom to.
 *  @param animated         A BOOL property to determine whether the change of map's center should be animated or not.
 */
- (void) setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
