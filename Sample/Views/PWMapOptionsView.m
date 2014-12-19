//
//  PWMapOptionsView.m
//  PWMapKitSample
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWMapOptionsView.h"
#import "PWViewController.h"

#import <PWLocation/PWLocation.h>
#import <PWMapKit/PWMapKit.h>


@interface PWMapOptionsView () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, weak) PWViewController *viewController;
@property (nonatomic, strong) UIView *overlayView;

@end

@implementation PWMapOptionsView


#pragma mark - Initialization & Setup

- (instancetype)initWithViewController:(PWViewController *)viewController {
    self = [super initWithFrame:CGRectMake(0, 88, 320, 190)];
    
    if (self)
    {
        _viewController = viewController;
        [self _commonSetup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self _commonSetup];
    }
    
    return self;
}

- (void)_commonSetup
{
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    
    [self addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"standard"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"segmented"];
    
    [self.tableView reloadData];
}


#pragma mark - Public

- (void)showInView:(UIView *)view
{
    self.frame = CGRectMake(0, CGRectGetHeight(view.frame), CGRectGetWidth(view.frame), 190);
    
    [view addSubview:self];
    
    if (self.showBlock)
    {
        self.showBlock();
    }
    
    [self.overlayView removeFromSuperview];
    self.overlayView = [self overlayViewForView:view];
    self.overlayView.alpha = 0;
    
    [view insertSubview:self.overlayView belowSubview:self];
    
    __weak __typeof(self)weakSelf = self;
    
    // Show the options view
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.overlayView.alpha = 1;
        weakSelf.frame = CGRectMake(0, CGRectGetHeight(view.frame) - CGRectGetHeight(weakSelf.frame),
                                CGRectGetWidth(weakSelf.frame), CGRectGetHeight(weakSelf.frame));
    }];
}

- (void)dismiss
{
    [self dismissOverlayView:nil];
}


#pragma mark - User Actions

- (void)mapTypeChanged:(UISegmentedControl *)control
{
    [self.viewController.mapView setMapType:control.selectedSegmentIndex];
}

- (void)locationProviderChanged:(UISegmentedControl *)control
{
    self.viewController.mapView.indoorUserTrackingMode = PWIndoorUserTrackingModeFollow;
    [self.viewController registerLocationManager:control.selectedSegmentIndex];
}

#pragma mark - Convenience

- (UIView *)overlayViewForView:(UIView *)view
{
    UIView *overlayView = [[UIView alloc] initWithFrame:view.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissOverlayView:)];
    [overlayView addGestureRecognizer:tapGestureRecognizer];
    
    return overlayView;
}

- (void)dismissOverlayView:(UIGestureRecognizer *)recognizer
{
    __weak __typeof(self)weakSelf = self;
    
    if (self.dismissBlock)
    {
        self.dismissBlock();
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.overlayView.alpha = 0;
        weakSelf.frame = CGRectOffset(weakSelf.frame, 0, CGRectGetHeight(weakSelf.frame));
    } completion:^(BOOL finished) {
        [weakSelf.overlayView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = 1;
    
    switch (section)
    {
        case 2:
            numberOfRowsInSection = 2;
            break;
            
        default:
            break;
    }
    
    return numberOfRowsInSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section)
    {
        case 0:
            cell = [self segmentedCellForIndexPath:indexPath];
            break;
            
        case 1:
            cell = [self segmentedProviderCellForIndexPath:indexPath];
            break;
            
        case 2:
            cell = [self standardCellForIndexPath:indexPath];
            break;
            
        default:
            cell = [self standardCellForIndexPath:indexPath];
            break;
    }
    
    return cell;
}


#pragma mark - Cells

- (UITableViewCell *)standardCellForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"standard" forIndexPath:indexPath];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = self.tintColor;
	
    if (indexPath.section == 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"";
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"Clear Cache";
                break;
                
            case 1:
                cell.textLabel.text = @"Drop Pin";
                break;
                
            default:
                cell.textLabel.text = @"";
                break;
        }
    }

    return cell;
}

- (UITableViewCell *)segmentedCellForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"standard" forIndexPath:indexPath];
    
    UISegmentedControl *mapTypeControl = (UISegmentedControl *) [cell viewWithTag:500];
    
    if (mapTypeControl == nil)
    {
        mapTypeControl = [[UISegmentedControl alloc] initWithItems:@[@"Standard", @"Satellite", @"Hybrid"]];
        mapTypeControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        mapTypeControl.selectedSegmentIndex = [(MKMapView *)self.viewController.mapView mapType];
        [mapTypeControl addTarget:self action:@selector(mapTypeChanged:) forControlEvents:UIControlEventValueChanged];
        
        mapTypeControl.frame = CGRectMake(20, 10, 280, 29);
        
        [cell.contentView addSubview:mapTypeControl];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"";
    
    return cell;
}

- (UITableViewCell *)segmentedProviderCellForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"standard" forIndexPath:indexPath];
    
    UISegmentedControl *mapTypeControl = (UISegmentedControl *) [cell viewWithTag:600];
    
    if (mapTypeControl == nil)
    {
        mapTypeControl = [[UISegmentedControl alloc] initWithItems:@[@"MSE", @"BLE", @"MOCK"]];
        mapTypeControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        mapTypeControl.selectedSegmentIndex = 1;
        [mapTypeControl addTarget:self action:@selector(locationProviderChanged:) forControlEvents:UIControlEventValueChanged];
        
        mapTypeControl.frame = CGRectMake(20, 10, 280, 29);
        
        [cell.contentView addSubview:mapTypeControl];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"";
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 6.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 && indexPath.section == 2) {
        UIAlertView *confirmClearCache = [[UIAlertView alloc] initWithTitle:@"Clear Cache"
                                                                    message:@"Are you sure you want to clear cache?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:@"OK",
                                          nil];
        [confirmClearCache show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        // Confirmed to clear cache
        [[PWBuildingManager sharedManager] clearCache];
    }
}

@end
