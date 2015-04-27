//
//  PWPitchBarButtonItem.m
//  PWMapKitSample
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "PWPitchBarButtonItem.h"

static const CGFloat kAnimationDuration = 0.3f;

@interface PWToggleButton : UIButton

@property (nonatomic, assign) BOOL toggled;

+ (instancetype)button;

@end


@implementation PWToggleButton

+ (instancetype)button
{
    PWToggleButton *button = [PWToggleButton buttonWithType:UIButtonTypeCustom];
    button.toggled = NO;
    
    button.frame = CGRectMake(0, 0, 34, 34);
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:22.0f];
    [button setTitle:@"3D" forState:UIControlStateNormal];
    [button setTitleColor:button.tintColor forState:UIControlStateNormal];

    button.layer.cornerRadius = 3;
    
    return button;
}

@end

@interface PWPitchBarButtonItem ()

@property (nonatomic, weak) MKMapView *mapView;

@end

@implementation PWPitchBarButtonItem

- (instancetype)initWithMapView:(MKMapView *)mapView
{
    PWToggleButton *button = [PWToggleButton button];
    self = [super initWithCustomView:button];
    
    self.mapView = mapView;
    
    [self updateButtonState];
    
    if (self)
    {
        [button addTarget:self action:@selector(togglePitch) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)togglePitch
{
    [self.mapView setPitchEnabled:!self.mapView.isPitchEnabled];
    [self updateMapView];
}

- (void)updateMapView
{
    [self.mapView setShowsBuildings:self.mapView.pitchEnabled];
    
    MKMapCamera *newCamera = [[self.mapView camera] copy];
    
    if (self.mapView.pitchEnabled)
    {
        [newCamera setPitch:45.0];
        [newCamera setAltitude:200];
    }
    else
    {
        [newCamera setPitch:0];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView setCamera:newCamera animated:YES];
    });
}

- (void)updateButtonState
{
    UIColor *backgroundColor = (self.mapView.pitchEnabled ? [UIColor colorWithRed:223/255.f green:234/255.f blue:246/255.0f alpha:1] : [UIColor clearColor]);
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        PWToggleButton *button = (PWToggleButton *)self.customView;
        [button setBackgroundColor:backgroundColor];
    }];
}

@end
