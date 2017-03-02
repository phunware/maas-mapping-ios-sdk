//
//  TrackingModeView.m
//  PWLocation
//
//  Created on 1/25/17.
//  Copyright © 2017 Phunware Inc. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PureLayout/PureLayout.h>
#import <QuartzCore/QuartzCore.h>

#import "TrackingModeView.h"
#import "CommonSettings.h"

static CGRect buttonFrame = {0, 0, 34, 34};

@interface TrackingModeView ()

@property (nonatomic, strong) PWMapView *mapView;
@property (nonatomic, strong) UIButton *noTrackingButton;
@property (nonatomic, strong) UIButton *trackingFollowButton;
@property (nonatomic, strong) UIButton *trackingFollowWithHeadingButton;

@end

@implementation TrackingModeView

- (instancetype)initWithMapView:(PWMapView *)mapView {
    UIView *containerView = [[UIView alloc] initWithFrame:buttonFrame];
    if (self = [super initWithCustomView:containerView]) {
        self.mapView = mapView;
        [self setupButtons];
        [self updateButtonStateAnimated:NO];
    }
    return self;
}

- (void)setupButtons {
    [self configureNoTrackingButton];
    [self configureFollowButton];
    [self configureFollowWithHeadingButton];
}

- (void)configureNoTrackingButton {
    UIButton *noTrackingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    noTrackingButton.tintColor = [UIColor whiteColor];
    noTrackingButton.accessibilityValue = PWLocalizedString(@"LocateMeButton", @"Locate Me");
    noTrackingButton.accessibilityHint = PWLocalizedString(@"LocateMeButtonHint", @"Double tap to turn to follow me mode");
    noTrackingButton.backgroundColor = [UIColor clearColor];
    [noTrackingButton setImage:[self locateMe:noTrackingButton.tintColor] forState:UIControlStateNormal];
    noTrackingButton.hidden = YES;
    [noTrackingButton addTarget:self action:@selector(locateAndTrackIndoorUser) forControlEvents:UIControlEventTouchUpInside];
    
    [self.customView addSubview:noTrackingButton];
    [self configureConstraintsForButton:noTrackingButton];
    self.noTrackingButton = noTrackingButton;
}

- (void)configureFollowButton {
    UIButton *trackingFollowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    trackingFollowButton.backgroundColor = [UIColor clearColor];
    trackingFollowButton.accessibilityValue = PWLocalizedString(@"FollowMeButton", @"Follow Me");
    trackingFollowButton.accessibilityHint = PWLocalizedString(@"FollowMeButtonHint", @"Double tap to turn to follow me with heading mode");
    [trackingFollowButton setImage:[self locateMeFilled:self.noTrackingButton.tintColor] forState:UIControlStateNormal];
    [trackingFollowButton setImage:[self locateMeFilled:self.noTrackingButton.tintColor] forState:UIControlStateHighlighted];
    trackingFollowButton.hidden = YES;
    [trackingFollowButton addTarget:self action:@selector(locateAndTrackIndoorUserWithHeading) forControlEvents:UIControlEventTouchUpInside];
    
    [self.customView addSubview:trackingFollowButton];
    [self configureConstraintsForButton:trackingFollowButton];
    self.trackingFollowButton = trackingFollowButton;
}

- (void)configureFollowWithHeadingButton {
    UIButton *trackingFollowWithHeadingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    trackingFollowWithHeadingButton.backgroundColor = [UIColor clearColor];
    trackingFollowWithHeadingButton.accessibilityValue = PWLocalizedString(@"FollowMeHeadingButton", @"Follow me with heading");
    trackingFollowWithHeadingButton.accessibilityHint = PWLocalizedString(@"FollowMeHeadingButtonHint", @"Double tap to turn to locate me mode");
    CGFloat spacing = 5; // the amount of spacing to appear between image and title
    trackingFollowWithHeadingButton.imageEdgeInsets = UIEdgeInsetsMake(spacing, 1, 0, 0);
    trackingFollowWithHeadingButton.titleEdgeInsets = UIEdgeInsetsMake(spacing, 0, 0, 0);
    
    [trackingFollowWithHeadingButton setImage:[self trackMe:self.noTrackingButton.tintColor] forState:UIControlStateNormal];
    [trackingFollowWithHeadingButton setImage:[self trackMe:self.noTrackingButton.tintColor] forState:UIControlStateHighlighted];
    trackingFollowWithHeadingButton.hidden = YES;
    [trackingFollowWithHeadingButton addTarget:self action:@selector(disableIndoorTracking) forControlEvents:UIControlEventTouchUpInside];
    
    [self.customView addSubview:trackingFollowWithHeadingButton];
    [self configureConstraintsForButton:trackingFollowWithHeadingButton];
    self.trackingFollowWithHeadingButton = trackingFollowWithHeadingButton;
}

- (void)configureConstraintsForButton:(UIButton *)button {
    [button autoPinEdgesToSuperviewEdges];
}

#pragma mark - State Management

- (void)updateButtonStateAnimated:(BOOL)animated {
    UIButton *displayedButton = [self displayedButton];
    UIButton *buttonToDisplay = nil;
    NSTimeInterval animationDuration = (animated ? 0.3 : 0);
    
    switch (self.mapView.trackingMode) {
        case PWTrackingModeNone:
            buttonToDisplay = self.noTrackingButton;
            break;
            
        case PWTrackingModeFollow:
            buttonToDisplay = self.trackingFollowButton;
            break;
            
        case PWTrackingModeFollowWithHeading:
            buttonToDisplay = self.trackingFollowWithHeadingButton;
            break;
            
        default:
            break;
    }
    
    if (displayedButton != buttonToDisplay) {
        [UIView animateWithDuration:animationDuration animations:^{
            displayedButton.alpha = 0;
        } completion:^(BOOL finished) {
            displayedButton.hidden = YES;
        }];
        
        buttonToDisplay.alpha = 0;
        buttonToDisplay.hidden = NO;
        buttonToDisplay.transform = CGAffineTransformMakeScale(0.2, 0.2);
        
        [UIView animateWithDuration:animationDuration animations:^{
            buttonToDisplay.alpha = 1;
            buttonToDisplay.transform = CGAffineTransformIdentity;
        }];
    }
}

- (UIButton *)displayedButton {
    if (!self.noTrackingButton.hidden) {
        return self.noTrackingButton;
    }
    else if (!self.trackingFollowButton.hidden) {
        return self.trackingFollowButton;
    }
    else if (!self.trackingFollowWithHeadingButton.hidden) {
        return self.trackingFollowWithHeadingButton;
    }
    
    return nil;
}

#pragma mark - Actions

- (void)disableIndoorTracking {
    self.mapView.trackingMode = PWTrackingModeNone;
}

- (void)locateAndTrackIndoorUser {
    self.mapView.trackingMode = PWTrackingModeFollow;
}

- (void)locateAndTrackIndoorUserWithHeading {
    self.mapView.trackingMode = PWTrackingModeFollowWithHeading;
}

#pragma mark - Drawing

- (UIImage *)locateMe:(UIColor *)tintColor {
    CGRect rect = CGRectMake(0, 0, 24, 24);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(13.53, 24)];
    [bezierPath addLineToPoint: CGPointMake(13.44, 10.62)];
    [bezierPath addLineToPoint: CGPointMake(0, 10.71)];
    [bezierPath addLineToPoint: CGPointMake(24, 0)];
    [bezierPath addLineToPoint: CGPointMake(13.53, 24)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(14.31, 9.74)];
    [bezierPath addLineToPoint: CGPointMake(14.38, 19.85)];
    [bezierPath addLineToPoint: CGPointMake(22.29, 1.7)];
    [bezierPath addLineToPoint: CGPointMake(4.16, 9.81)];
    [bezierPath addLineToPoint: CGPointMake(14.31, 9.74)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    [tintColor setFill];
    [bezierPath fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)locateMeFilled:(UIColor *)tintColor {
    CGRect rect = CGRectMake(0, 0, 22, 22);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(12.4, 22)];
    [bezierPath addLineToPoint: CGPointMake(12.33, 9.74)];
    [bezierPath addLineToPoint: CGPointMake(0, 9.81)];
    [bezierPath addLineToPoint: CGPointMake(22, 0)];
    [bezierPath addLineToPoint: CGPointMake(12.4, 22)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    [tintColor setFill];
    [bezierPath fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)trackMe:(UIColor *)tintColor {
    CGRect rect = CGRectMake(0, 0, 15, 26);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(6.98, 0)];
    [bezierPath addLineToPoint: CGPointMake(8, 0)];
    [bezierPath addLineToPoint: CGPointMake(8, 6.01)];
    [bezierPath addLineToPoint: CGPointMake(6.98, 6.01)];
    [bezierPath addLineToPoint: CGPointMake(6.98, 0)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(7.44, 19.01)];
    [bezierPath addLineToPoint: CGPointMake(0, 26)];
    [bezierPath addLineToPoint: CGPointMake(7.39, 8.01)];
    [bezierPath addLineToPoint: CGPointMake(15, 25.91)];
    [bezierPath addLineToPoint: CGPointMake(7.44, 19.01)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    [tintColor setFill];
    [bezierPath fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
