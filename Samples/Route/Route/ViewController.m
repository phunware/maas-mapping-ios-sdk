//
//  ViewController.m
//  LoadMap
//
//  Created on 7/25/16.
//  Copyright © 2016 Phunware Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *goButton;

- (IBAction)goViewController:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)goViewController:(id)sender {
    [PWBuilding buildingWithIdentifier:20234 usingCache:YES completion:^(PWBuilding *building, NSError *error) {
        // UI view controller initialization
        PWRouteViewController *routeViewController = [[PWRouteViewController alloc] initWithBuilding:building];
        routeViewController.delegate = self;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:routeViewController];
        // Present
        [self presentViewController:navigationController animated:YES completion:^{
        }];
    }];
}

#pragma mark - PWRouteViewControllerDelegate

- (void) didCalculateRoute:(PWRoute *) route {
    // To do something by yourself
    
    NSLog(@"The route is returned.");
}

- (void) didDismissRouteViewController:(PWRouteInstruction *) instruction {
    
}

@end
