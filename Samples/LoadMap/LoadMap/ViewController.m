//
//  ViewController.m
//  LoadMap
//
//  Created on 7/25/16.
//  Copyright © 2016 Phunware Inc. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>
#import <PWLocation/PWLocation.h>

#import "ViewController.h"

#define kBLECustomerIdentifier @"<Senion Customer Identifier>"
#define kBLEMapIdentifier @"<Senion Map Identifier>"
#define kVirtualBeaconToken @"<Senion Map Identifier>"
#define kBuildingIdentifier 0

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loadMapButton;

- (IBAction)loadMap:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize size = self.loadMapButton.frame.size;
    UIBezierPath *path = [self arrowFramePath:size];
    
    CAShapeLayer *shapeView = [[CAShapeLayer alloc] init];
    [shapeView setPath:path.CGPath];
    shapeView.fillColor = UIColor.whiteColor.CGColor;
    shapeView.lineWidth = 1.0;
    shapeView.strokeColor = UIColor.grayColor.CGColor;
    [self.loadMapButton.layer addSublayer:shapeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loadMap:(id)sender {
    [PWBuilding buildingWithIdentifier:kBuildingIdentifier completion:^(PWBuilding *building, NSError *error) {
        // UI view controller initialization
        PWMapViewController *mapViewController = [[PWMapViewController alloc] initWithBuilding:building];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
        // Present
        [self presentViewController:navigationController animated:YES completion:^{
            // Set center of map
            [mapViewController setCenterCoordinate:building.coordinate zoomLevel:19 animated:NO];
            
            // Initialize the manager
            PWManagedLocationManager *manager = [[PWManagedLocationManager alloc] initWithBuildingId:kBuildingIdentifier];
            
            // Configure the internal providers
            manager.senionCustomerID = kBLECustomerIdentifier;
            manager.senionMapID = kBLEMapIdentifier;
            manager.virtualBeaconToken = kVirtualBeaconToken;
            
            // Regester the manager
            [mapViewController.mapView registerLocationManager:manager];
        }];
    }];
}

- (UIBezierPath *)arrowFramePath:(CGSize)size
{
    CGFloat radius = 5.0;
    CGFloat arrowWidth = 5.0;
    UIBezierPath *path = [UIBezierPath bezierPath];
    // top left
    [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI endAngle:3*M_PI_2 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(size.width/2 - arrowWidth, 0)];
    [path addLineToPoint:CGPointMake(size.width/2, -arrowWidth)];
    [path addLineToPoint:CGPointMake(size.width/2 + arrowWidth, 0)];
    
    [path addArcWithCenter:CGPointMake(size.width - radius, radius) radius:radius startAngle:3*M_PI_2 endAngle:0 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(size.width, size.height/2 - arrowWidth)];
    [path addLineToPoint:CGPointMake(size.width + arrowWidth, size.height/2)];
    [path addLineToPoint:CGPointMake(size.width, size.height/2 + arrowWidth)];
    
    [path addArcWithCenter:CGPointMake(size.width - radius, size.height - radius) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(size.width/2 + arrowWidth, size.height)];
    [path addLineToPoint:CGPointMake(size.width/2, size.height + arrowWidth)];
    [path addLineToPoint:CGPointMake(size.width/2 - arrowWidth, size.height)];
    
    [path addArcWithCenter:CGPointMake(radius, size.height - radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    
    [path addLineToPoint:CGPointMake(0, size.height/2 + arrowWidth)];
    [path addLineToPoint:CGPointMake(-arrowWidth, size.height/2)];
    [path addLineToPoint:CGPointMake(0, size.height/2 - arrowWidth)];
    
    [path closePath];
    
    return path;
}

@end
