//
//  PreRouteInstructionTableViewCell.h
//  PWMapKit
//
//  Created on 8/11/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWRouteInstruction;

extern NSString * const PreRouteInstructionCellReuseIdentifier;

@interface PreRouteInstructionTableViewCell : UITableViewCell

- (void)configureForRouteInstruction:(PWRouteInstruction *)routeInstruction;

@end
