//
//  POIDetailsTableViewCell.h
//  PWMapKit
//
//  Created on 9/9/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const POIDetailsCellReuseIdentifier;

@interface POIDetailsTableViewCell : UITableViewCell

- (void)configureForKey:(NSString *)keyString value:(NSString *)valueString;

@end
