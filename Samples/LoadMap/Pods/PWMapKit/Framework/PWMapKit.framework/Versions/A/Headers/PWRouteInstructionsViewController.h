//
//  PWRouteInstructionsViewController.h
//  PWMapKit
//
//  Created by Steven Spry on 5/12/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PWRoute.h"
#import "PWRouteInstruction.h"

/**
 *  Image name to use for the start pin. This image is supplied in the MNW_Images.xcassets file.  You may change this image.
 */
static NSString *const kPWDirectionStartPin = @"PWDirectionStartPin";

/**
 *  Image name to use for the end pin. This image is supplied in the MNW_Images.xcassets file.  You may change this image.
 */
static NSString *const kPWDirectionEndPin = @"PWDirectionEndPin";

/**
 *  PWRouteInstructionsViewControllerDelegate protocol definition.
 */
@protocol PWRouteInstructionsViewControllerDelegate <NSObject>
@optional

/**
 *  This delegate is called when the user has selected one route instruction for the calculated route.
 *
 *  @param instruction A reference to the selected instruction object.
 */
- (void) didSelectRouteInstruction:(PWRouteInstruction *) instruction;

/**
 *  Informs the receiver that the user dismissed the view controller, and returns the instruction last used (if any).
 *
 *  @param instruction A PWRouteInstruction object last used after the dismissal.
 */
- (void) didDismissRouteViewController:(PWRouteInstruction *) instruction;

@end

/**
 *  The PWRouteInstructionsViewController allows the display of a route instructions list for a calculated PWRoute.
 */
@interface PWRouteInstructionsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  The receiver’s delegate.
 */
@property (nonatomic) id<PWRouteInstructionsViewControllerDelegate> delegate;

/**---------------------------------------------------------------------------------------
 * @name Instance Methods
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Creates a PWRouteInstructionsView instance for the given route.
 *
 *  @param route A PWRoute reference.
 *
 *  @return Returns a PWRouteInstructionsView instance.
 */
- (instancetype) initWithRoute:(PWRoute *)route;

@end
