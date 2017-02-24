//
//  ShowAllStepsTableViewCell.h
//  Maps-Samples
//
//  Created on 9/16/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const ShowAllStepsCellReuseIdentifier;

@interface ShowAllStepsTableViewCell : UITableViewCell

- (void)configureForShowAllStepsSelector:(SEL)showAllStepsSelector showAllStepsTarget:(id)showAllStepsTarget;

@end
