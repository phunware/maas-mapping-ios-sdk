//
//  PWBuildingViewController.h
//  PWMapKit
//
//  Created by Steven Spry on 5/12/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWBuilding.h"
#import "PWPointOfInterest.h"

/**
 *  PWBuildingViewControllerDelegate protocol definition.
 */
@protocol PWBuildingViewControllerDelegate <NSObject>
@optional
/**
 *  Informs the receiver that the user selected a point of interest.
 *
 *  @param poi The selected point of interest.
 */
- (void) didSelectPointOfInterest:(PWPointOfInterest *) poi;

/**
 *  Informs the receiver that the user dismissed the view controller and returns the point of interest last selected (if any).
 *
 *  @param poi the last selected point of interest.
 */
- (void) didDismissBuildingViewController:(PWPointOfInterest *) poi;

@end

/**
 *  A view controller that let's the user browse and search a PWBuilding structure.
 */
@interface PWBuildingViewController : UIViewController

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  The receiver’s delegate.
 */
@property (nonatomic) id<PWBuildingViewControllerDelegate> delegate;

/**---------------------------------------------------------------------------------------
 * @name Instance Methods
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Initializes a PWBuildingViewController instance for a given PWBuilding object.
 *
 *  @param building A PWBuilding object.
 *
 *  @return Returns a PWBuildingViewController instance.
 */
- (instancetype) initWithBuilding:(PWBuilding *)building;

/**
 *  Filters the building's points of interest list with the given string.
 *
 *  @param filterText String value to filter building's POI list.
 */
- (void) setFilterText:(NSString *) filterText;

@end
