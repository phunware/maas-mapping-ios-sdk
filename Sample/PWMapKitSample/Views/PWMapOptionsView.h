//
//  PWMapOptionsView.h
//  PWMapKitSample
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;

typedef void (^PWMapOptionsViewBlock)(void);

@interface PWMapOptionsView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) PWMapOptionsViewBlock showBlock;
@property (nonatomic, copy) PWMapOptionsViewBlock dismissBlock;

- (instancetype)initWithMapView:(MKMapView *)mapView;
- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
