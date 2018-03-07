//
//  ViewController.m
//  MapScenariosObjC
//
//  Created on 3/5/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

#import <PWCore/PWCore.h>

#import "ScenarioSelectViewController.h"
#import "BluedotLocationViewController.h"
#import "LoadBuildingViewController.h"
#import "LocationModesViewController.h"
#import "CustomPOIViewController.h"
#import "RoutingViewController.h"

// Enter your application identifier, access key, and signature key, found on Maas portal under Account > Apps
// These are universal across all view controllers but will be overridden by configured values in the individual controllers
static NSString *universalApplicationId = @"";
static NSString *universalAccessKey = @"";
static NSString *universalSignatureKey = @"";
// Building identifier to be used in all view controllers, overridden when set in individual controllers
static NSInteger universalBuildingIdentifier = 0;

@interface ScenarioSelectViewController ()

@end

@implementation ScenarioSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (universalApplicationId.length > 0 && universalAccessKey.length > 0 && universalSignatureKey.length > 0) {
        [PWCore setApplicationID:universalApplicationId accessKey:universalAccessKey signatureKey:universalSignatureKey];
    }
    
    if ([segue.identifier isEqualToString:NSStringFromClass([BluedotLocationViewController class])]) {
        BluedotLocationViewController *bluedotLocationViewController = segue.destinationViewController;
        if (bluedotLocationViewController.buildingIdentifier == 0) {
            bluedotLocationViewController.buildingIdentifier = universalBuildingIdentifier;
        }
    } else if ([segue.identifier isEqualToString:NSStringFromClass([LoadBuildingViewController class])]) {
        LoadBuildingViewController *loadBuildingViewController = segue.destinationViewController;
        if (loadBuildingViewController.buildingIdentifier == 0) {
            loadBuildingViewController.buildingIdentifier = universalBuildingIdentifier;
        }
    } else if ([segue.identifier isEqualToString:NSStringFromClass([LocationModesViewController class])]) {
        LocationModesViewController *locationModesViewController = segue.destinationViewController;
        if (locationModesViewController.buildingIdentifier == 0) {
            locationModesViewController.buildingIdentifier = universalBuildingIdentifier;
        }
    } else if ([segue.identifier isEqualToString:NSStringFromClass([CustomPOIViewController class])]) {
        CustomPOIViewController *customPOIViewController = segue.destinationViewController;
        if (customPOIViewController.buildingIdentifier == 0) {
            customPOIViewController.buildingIdentifier = universalBuildingIdentifier;
        }
    } else if ([segue.identifier isEqualToString:NSStringFromClass([RoutingViewController class])]) {
        RoutingViewController *routingViewController = segue.destinationViewController;
        if (routingViewController.buildingIdentifier == 0) {
            routingViewController.buildingIdentifier = universalBuildingIdentifier;
        }
    }
}

@end
