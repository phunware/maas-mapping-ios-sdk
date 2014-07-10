//
//  PWView.h
//  PWMapKitSample
//
//  Created by Saumitra Vaidya on 4/3/14.
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PWMapKit/PWMapKit.h>

@interface PWView : UIView

@property (nonatomic, strong) PWMapView *mapView;
@property (nonatomic, strong) UIToolbar *toolbar;

@end
