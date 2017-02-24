//
//  RouteSummaryTableViewCell.h
//  PWMapKit
//
//  Created on 8/11/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWRoute;

extern NSString * const RouteSummaryTableViewCellReuseIdentifier;

@interface RouteSummaryTableViewCell : UITableViewCell

- (void)configureForRoute:(PWRoute *)route;

@end
