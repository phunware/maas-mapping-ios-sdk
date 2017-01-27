//
//  ViewController.m
//  LoadMap
//
//  Created on 7/25/16.
//  Copyright © 2016 Phunware Inc. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>

#import "ViewController.h"

#define kBLECustomerIdentifier @"<Senion Customer Identifier>"
#define kBLEMapIdentifier @"<Senion Map Identifier>"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loadMapButton;

- (IBAction)loadMap:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loadMap:(id)sender {
    [PWBuilding buildingWithIdentifier:20234 completion:^(PWBuilding *building, NSError *error) {
        // UI view controller initialization
        PWMapViewController *mapViewController = [[PWMapViewController alloc] initWithBuilding:building];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
        // Present
        [self presentViewController:navigationController animated:YES completion:^{
            // Set center of map
            [mapViewController setCenterCoordinate:building.coordinate zoomLevel:19 animated:NO];
            
            // Set indoor location manager
            NSDictionary *bleConfiguration = @{PWMapViewLocationTypeBLECustomIdentifierKey:kBLECustomerIdentifier,
                                               PWMapViewLocationTypeBLEMapIdentifierKey:kBLEMapIdentifier,
                                               PWMapViewLocationTypeFloorMapping:@{/* Floor ID Mapping, blue dot will not show without it. */}};
            [mapViewController.mapView setMapViewLocationType:PWMapViewLocationTypeBLE configuration:bleConfiguration];
        }];
    }];
}

@end
