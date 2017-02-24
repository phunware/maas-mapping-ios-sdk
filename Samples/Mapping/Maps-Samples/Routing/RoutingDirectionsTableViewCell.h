//
//  RouteInstructionTableViewCell.h
//  PWMapKit
//
//  Created on 8/15/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PWMapKit/PWMapKit.h>

extern NSString * const RoutingDirectionsTableViewCellReuseIdentifier;

@interface RoutingDirectionsTableViewCell : UITableViewCell

- (void)configureRouteInstruction:(PWRouteInstruction *)routeInstruction;

- (void)composeAccessibityLabel;

@end
