//
//  POITableViewCell.h
//  POI Management
//
//  Created by Illya Busigin on 4/13/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POITableViewCell : UITableViewCell

@property (weak, readonly) UIImageView *annotationImageView;
@property (weak, readonly) UILabel *annotationTitleLabel;
@property (weak, readonly) UILabel *annotationTypeLabel;

@end
