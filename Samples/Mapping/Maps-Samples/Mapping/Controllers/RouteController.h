//
//  RouteController.h
//  PWMapKit
//
//  Created on 8/18/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "DirectoryController.h"

@interface RouteController : DirectoryController

@property (nonatomic, strong) UIBarButtonItem *cancelBarButton;

@property (nonatomic, strong) UITextField *startField;
@property (nonatomic, strong) PWPointOfInterest *startPOI;

@property (nonatomic, strong) UITextField *endField;
@property (nonatomic, strong) PWPointOfInterest *endPOI;

@property (nonatomic, strong) UIButton *accessibilityButton;

@property (nonatomic, strong) UIButton *routeButton;

@end
