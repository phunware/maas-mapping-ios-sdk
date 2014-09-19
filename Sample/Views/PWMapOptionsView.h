//
//  PWMapOptionsView.h
//  PWMapKitSample
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWMockLocationManager;
@class PWMapView;

typedef void (^PWMapOptionsViewBlock)(void);

@class PWViewController;
@interface PWMapOptionsView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) PWMapOptionsViewBlock showBlock;
@property (nonatomic, copy) PWMapOptionsViewBlock dismissBlock;

- (instancetype)initWithViewController:(PWViewController *)viewController;
- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
