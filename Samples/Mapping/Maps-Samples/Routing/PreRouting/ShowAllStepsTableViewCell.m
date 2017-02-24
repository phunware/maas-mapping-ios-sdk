//
//  ShowAllStepsTableViewCell.m
//  Maps-Samples
//
//  Created on 9/16/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import <QuartzCore/QuartzCore.h>

#import "ShowAllStepsTableViewCell.h"
#import "CommonSettings.h"

NSString * const ShowAllStepsCellReuseIdentifier = @"ShowAllStepsReuseIdentifier";

@interface ShowAllStepsTableViewCell ()

@property (nonatomic, strong) UIButton *showAllStepsButton;

@end

@implementation ShowAllStepsTableViewCell

- (void)configureForShowAllStepsSelector:(SEL)showAllStepsSelector showAllStepsTarget:(id)showAllStepsTarget {
    if (self.showAllStepsButton != nil || ![self.showAllStepsButton isDescendantOfView:self]) {
        self.showAllStepsButton = [UIButton new];
        [self addSubview:self.showAllStepsButton];
    }
    
    [self.showAllStepsButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.showAllStepsButton addTarget:showAllStepsTarget action:showAllStepsSelector forControlEvents:UIControlEventTouchUpInside];
    [self.showAllStepsButton setTitle:PWLocalizedString(@"ShowAllStepsButton", @"SHOW ALL STEPS") forState:UIControlStateNormal];
    self.showAllStepsButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.showAllStepsButton.backgroundColor = [CommonSettings commonButtonBackgroundColor];
    [self.showAllStepsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.showAllStepsButton.clipsToBounds = YES;
    self.showAllStepsButton.layer.cornerRadius = 15;
    self.showAllStepsButton.accessibilityHint = PWLocalizedString(@"ShowAllStepsButtonHint", @"Tap to show all route steps");
    
    [self.showAllStepsButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 20, 10, 20)];
    [self.showAllStepsButton autoSetDimension:ALDimensionHeight toSize:30];
}

@end
