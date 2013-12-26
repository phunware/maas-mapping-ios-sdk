//
//  RootViewController.m
//  PWMapKitSamples
//
//  Copyright (c) 2013 Phunware Inc. All rights reserved.
//

#import "RootViewController.h"

#import <PWMapKit/PWMapKit.h>
#import <PWMapKit/PWBuildingFloor.h>
#import <PWMapKit/PWMapAnnotation.h>
#import <PWMapKit/PWRoute.h>

@interface RootViewController () <PWMapViewDelegate>
@property(nonatomic,weak) PWMapView *mapView;

@property(nonatomic,weak) UIButton *getFloorsButton;
@property(nonatomic,weak) UIButton *switchFloorButton;
@property(nonatomic,weak) UIButton *toggleBlueDotButton;
@property(nonatomic,weak) UIButton *getAllAnnotationsButton;
@property(nonatomic,weak) UIButton *centerAnnotationButton;
@property(nonatomic,weak) UIButton *drawRouteButton;
@property(nonatomic,weak) UIButton *clearRouteButton;

@end

@implementation RootViewController
- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat xCoord = 0.0;
    CGFloat yCoord = 0.0;
    
    CGRect mapRect = CGRectMake(xCoord, yCoord, self.view.frame.size.width, self.view.frame.size.height/2);
    PWMapView *mapView = [[PWMapView alloc] initWithFrame:mapRect buildingID:@"150" venueID:@"e2a53fd8-6dcc-48e1-8b33-71f12fc13966"];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    _mapView = mapView;
    
    xCoord = 10;
    yCoord += mapRect.size.height + 10;
    
    UIButton *getFloorsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [getFloorsButton addTarget:self action:@selector(getFloorsAction) forControlEvents:UIControlEventTouchUpInside];
    [getFloorsButton setTitle:@"Get Floors" forState:UIControlStateNormal];
    [getFloorsButton setFrame:CGRectMake(xCoord, yCoord, 120, 35)];
    [getFloorsButton setBackgroundColor:[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0]];
    [self.view addSubview:getFloorsButton];
    self.getFloorsButton = getFloorsButton;
    
    xCoord = 10;
    yCoord += getFloorsButton.frame.size.height + 10;
    
    UIButton *switchFloorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [switchFloorButton addTarget:self action:@selector(switchFloorAction) forControlEvents:UIControlEventTouchUpInside];
    [switchFloorButton setTitle:@"Switch Floor" forState:UIControlStateNormal];
    [switchFloorButton setFrame:CGRectMake(xCoord, yCoord, 120, 35)];
    [switchFloorButton setBackgroundColor:[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0]];
    [self.view addSubview:switchFloorButton];
    self.switchFloorButton = switchFloorButton;
    
    xCoord = 10;
    yCoord += switchFloorButton.frame.size.height + 10;
    
    UIButton *toggleBlueDotButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [toggleBlueDotButton addTarget:self action:@selector(toggleBlueDotAction) forControlEvents:UIControlEventTouchUpInside];
    [toggleBlueDotButton setTitle:@"BlueDot: Off" forState:UIControlStateNormal];
    [toggleBlueDotButton setFrame:CGRectMake(xCoord, yCoord, 120, 35)];
    [toggleBlueDotButton setBackgroundColor:[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0]];
    [self.view addSubview:toggleBlueDotButton];
    self.toggleBlueDotButton = toggleBlueDotButton;
    
    xCoord = 10;
    yCoord += toggleBlueDotButton.frame.size.height + 10;
    
    UIButton *getAllAnnotationsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [getAllAnnotationsButton addTarget:self action:@selector(getAllAnnotationsAction) forControlEvents:UIControlEventTouchUpInside];
    [getAllAnnotationsButton setTitle:@"Get Annotations" forState:UIControlStateNormal];
    [getAllAnnotationsButton setFrame:CGRectMake(xCoord, yCoord, 120, 35)];
    [getAllAnnotationsButton setBackgroundColor:[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0]];
    [self.view addSubview:getAllAnnotationsButton];
    self.getAllAnnotationsButton = getAllAnnotationsButton;
    
    xCoord = 10;
    yCoord += getAllAnnotationsButton.frame.size.height + 10;
    
    
    UIButton *centerAnnotationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [centerAnnotationButton addTarget:self action:@selector(centerAnnotationAction) forControlEvents:UIControlEventTouchUpInside];
    [centerAnnotationButton setTitle:@"Center On Point" forState:UIControlStateNormal];
    [centerAnnotationButton setFrame:CGRectMake(xCoord, yCoord, 120, 35)];
    [centerAnnotationButton setBackgroundColor:[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0]];
    [self.view addSubview:centerAnnotationButton];
    self.centerAnnotationButton = centerAnnotationButton;
    
    xCoord = 10 + 10 + getFloorsButton.frame.size.width;
    yCoord = mapRect.size.height + 10;
    
    UIButton *drawRouteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [drawRouteButton addTarget:self action:@selector(drawRouteAction) forControlEvents:UIControlEventTouchUpInside];
    [drawRouteButton setTitle:@"Draw Route" forState:UIControlStateNormal];
    [drawRouteButton setFrame:CGRectMake(xCoord, yCoord, 120, 35)];
    [drawRouteButton setBackgroundColor:[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0]];
    [self.view addSubview:drawRouteButton];
    self.drawRouteButton = drawRouteButton;
    
    xCoord = 10 + 10 + drawRouteButton.frame.size.width;
    yCoord += drawRouteButton.frame.size.height + 10;
    
    UIButton *clearRouteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clearRouteButton addTarget:self action:@selector(clearRouteAction) forControlEvents:UIControlEventTouchUpInside];
    [clearRouteButton setTitle:@"Clear Route" forState:UIControlStateNormal];
    [clearRouteButton setFrame:CGRectMake(xCoord, yCoord, 120, 35)];
    [clearRouteButton setBackgroundColor:[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0]];
    [self.view addSubview:clearRouteButton];
    self.clearRouteButton = clearRouteButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action Methods

- (void)getFloorsAction
{
    NSString *message = [NSString stringWithFormat:@"%@",self.mapView.floors];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"getFloors" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)switchFloorAction
{
    if (self.mapView.floors.count == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"switchFloorAction" message:@"Only 1 floor available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        PWBuildingFloor *currentFloor = self.mapView.currentFloor;
        
        for (int i=0; i<self.mapView.floors.count; i++)
        {
            if (((PWBuildingFloor*)[self.mapView.floors objectAtIndex:i]).floorID == currentFloor.floorID)
            {
                int nextFloorIndex = (i == self.mapView.floors.count - 1) ? 0 : i+1;
                [self.mapView setCurrentFloor:[self.mapView.floors objectAtIndex:nextFloorIndex]];
                return;
            }
        }
    }
}

- (void)toggleBlueDotAction
{
    if ([self.mapView trackingEnabled] == YES)
    {
        [self.toggleBlueDotButton setTitle:@"BlueDot: Off" forState:UIControlStateNormal];
        [self.mapView toggleLocationTrackingWithCompletion:^(BOOL didSucceed, NSError *error){
            if (error)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"toggleBlueDotAction" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            if (didSucceed == YES)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"toggleBlueDotAction" message:@"BlueDot disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
    else
    {
        
        [self.mapView toggleLocationTrackingWithCompletion:^(BOOL didSucceed, NSError *error){
            
            if (error)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"toggleBlueDotAction" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            if (didSucceed == YES)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"toggleBlueDotAction" message:@"BlueDot enabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [self.toggleBlueDotButton setTitle:@"BlueDot: On" forState:UIControlStateNormal];
            }
        }];
    }
}

- (void)getAllAnnotationsAction
{
    NSString *message = [NSString stringWithFormat:@"%@",self.mapView.annotations];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"getAnnotations" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}

- (void)drawRouteAction
{
    PWMapAnnotation *startAnnotation = [self.mapView.annotations objectAtIndex:(0 + arc4random_uniform(self.mapView.annotations.count + 1))];
    PWMapAnnotation *endAnnotation = [self.mapView.annotations objectAtIndex:(0 + arc4random_uniform(self.mapView.annotations.count + 1))];
    
    [PWMapKit getRouteFromAnnotationID:startAnnotation.annotationID toAnnotationID:endAnnotation.annotationID completion:^(PWRoute *route, NSError *error){
        if (error == nil)
        {
            [self.mapView loadRoute:route];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"drawRouteAction" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)clearRouteAction
{
    [self.mapView cancelRouting];
}

- (void)centerAnnotationAction
{
    PWMapAnnotation *annotation = [self.mapView.annotations objectAtIndex:(0 + arc4random_uniform(self.mapView.annotations.count))];
    [self.mapView setCenterCoordinate:annotation.location animated:YES];
}

#pragma mark - PWMapViewDelegate Methods

- (void)mapViewDidLoad:(PWMapView *)mapView
{
    NSLog(@"mapViewDidLoad:");
}

- (void)mapView:(PWMapView *)mapView failedToLoadWithError:(NSError *)error
{
    NSLog(@"mapView:failedToLoadWithError: %@", error);
}

- (void)mapView:(PWMapView *)mapView didSelectAnnotationView:(PWAnnotationView *)view
{
    NSLog(@"mapView:didSelectAnnotationView:");
    PWMapAnnotation *annotation = (PWMapAnnotation*)view.annotation;
    
    NSString *message = annotation.name;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"didSelectAnnotationView" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (PWAnnotationView *)mapView:(PWMapView *)mapView viewForAnnotation:(id<PWAnnotation>)annotation
{
    return nil;
}

- (void)mapView:(PWMapView *)mapView didUpdateToLocation:(CGPoint)location floorID:(NSUInteger)floorID
{
    
}

- (void)mapView:(PWMapView *)mapView didFailToUpdateLocationWithError:(NSError *)error
{
    
}

- (void)mapView:(PWMapView *)mapView didReceiveSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    
}

- (void)mapViewDidZoom:(PWMapView *)mapView
{
    
}

- (void)mapViewDidScroll:(PWMapView *)mapView
{
    
}

- (void)mapViewWillBeginDragging:(PWMapView *)mapView
{
    
}

- (void)mapViewWillEndDragging:(PWMapView *)mapView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
}

- (void)mapViewDidEndDragging:(PWMapView *)mapView willDecelerate:(BOOL)decelerate
{
    
}

- (void)mapViewWillBeginDecelerating:(PWMapView *)mapView
{
    
}

- (void)mapViewDidEndDecelerating:(PWMapView *)mapView
{
    
}

- (void)mapViewDidEndScrollingAnimation:(PWMapView *)mapView
{
    
}

@end
