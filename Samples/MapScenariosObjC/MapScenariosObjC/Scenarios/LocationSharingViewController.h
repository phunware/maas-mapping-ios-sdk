//
//  LocationSharingViewController.h
//  MapScenariosObjC
//
//  Created by Patrick Dunshee on 3/13/18.
//  Copyright © 2018 Patrick Dunshee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationSharingViewController : UIViewController

@property (nonatomic, strong) NSString *applicationId;
@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *signatureKey;
@property (nonatomic, assign) NSInteger buildingIdentifier;

@end
