//
//  PWRouteViewController.h
//  PWMapKit
//
//  Created by Steven Spry on 5/12/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PWRoute.h"
#import "PWRouteInstruction.h"
#import "PWCustomLocation.h"

/**
 *  Image name to use for the swap bar button item.   This image is supplied in the MNW_Images.xcassets file.  You may change this image.
 */
static NSString *const kPWNavigationSwapImage = @"PWNavigationSwapImage";

/**
 *  Image name to use for the accessibility bar button item.   This image is supplied in the MNW_Images.xcassets file.  You may change this image.
 */
static NSString *const kPWNavigationAccessibleImage = @"PWNavigationAccessibleImage";

/**
 *  PWRouteViewControllerDelegate protocol definition.
 */
@protocol PWRouteViewControllerDelegate <NSObject>
@optional

/**
 *  This delegate is called when the PWRouteViewController calculated a route successfully.
 *
 *  @param route The PWRoute calculated object.
 */
- (void) didCalculateRoute:(PWRoute *) route;

/**
 *  Informs the receiver that the user dismissed the view controller, and returns the instruction last used (if any).
 *
 *  @param instruction A PWRouteInstruction object last used after the dismissal.
 */
- (void) didDismissRouteViewController:(PWRouteInstruction *) instruction;

@end

/**
 *  A view controller that lets the user browse and search a PWBuilding structure to navigate from a start point of interest to an end point of interest.
 */
@interface PWRouteViewController : UIViewController

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  The receiver’s delegate.
 */
@property (nonatomic) id<PWRouteViewControllerDelegate> delegate;

/**
 *  A reference to a current custom location.
 */
@property (nonatomic) PWCustomLocation *customLocation;

/**
 *  A reference to the user's current location.
 */
@property (nonatomic) PWCustomLocation *userLocation;

/**---------------------------------------------------------------------------------------
 * @name Instance Methods
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Initializes a PWRouteViewController instance for a given building structure.
 *
 *  @param building A PWBuilding object.
 *
 *  @return Returns a PWRouteViewController instance.
 */
- (instancetype) initWithBuilding:(PWBuilding *)building;

/**
 *  Initializes a PWRouteViewController instance for a given building structure considering accessibility.
 *
 *  @param building   A PWBuilding object.
 *  @param accessible A BOOL value to determine if accessibility should be used while calculating the route.
 *
 *  @return Returns a PWRouteViewController instance.
 */
- (instancetype) initWithBuilding:(PWBuilding *)building withAccessibility:(BOOL) accessible;

@end
