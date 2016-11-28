//
//  PWPointOfInterestViewController.h
//  PWMapKit
//
//  Created by Steven Spry on 5/20/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PWPointOfInterest.h"

/**
 *  The PWPointOfInterestViewController allows you to display detailed information of a Point of Interest.
 */
@interface PWPointOfInterestViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

/**---------------------------------------------------------------------------------------
 * @name Instance Methods
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Initializes a PWPointOfInterestViewController with the supplied point of interest.
 *
 *  @param pointOfInterest A PWPointOfInterest object reference to initialize the PWPointOfInterestViewController object.
 *
 *  @return Returns a PWPointOfInterestViewController instance.
 */
- (instancetype) initWithPointOfInterest:(PWPointOfInterest *)pointOfInterest;

@end
