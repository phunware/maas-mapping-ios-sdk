//
//  RoutingViewController.h
//  MapScenariosObjC
//
//  Created on 3/7/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoutingViewController : UIViewController

@property (nonatomic, strong) NSString *applicationId;
@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *signatureKey;
@property (nonatomic, assign) NSInteger buildingIdentifier;

@end
