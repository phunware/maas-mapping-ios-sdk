//
//  PWRouteStartView.h
//  PWMapKit
//
//  Created by Steven Spry on 5/23/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PWRoute.h"
#import "PWRouteInstruction.h"

@protocol PWRouteStartViewDelegate <NSObject>
@optional
- (void) didSelectDetails:(PWRoute *) route;

@end


@interface PWRouteStartView : UIView
@property (strong,atomic) id<PWRouteStartViewDelegate> delegate;
- (void) setRoute:(PWRoute *)route;
@end
