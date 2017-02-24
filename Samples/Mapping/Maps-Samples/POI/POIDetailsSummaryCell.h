//
//  POIDetailsSummaryCell.h
//  PWMapKit
//
//  Created on 9/9/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const POIDetailsSummaryCellReuseIdentifier;

@interface POIDetailsSummaryCell : UITableViewCell

- (void)configureForSummary:(NSString *)summary;

@end
