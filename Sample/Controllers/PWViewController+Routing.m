//
//  PWViewController+Routing.m
//  PWMapKitSample
//
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import "PWViewController+Routing.h"

@implementation PWViewController (Routing)


#pragma mark - Setup

- (void)showRouteControls
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"765-arrow-left"] style:UIBarButtonItemStylePlain target:self action:@selector(showPreviousRouteStep)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"766-arrow-right"] style:UIBarButtonItemStylePlain target:self action:@selector(showNextRouteStep)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelRouting)];
    
    if (self.mapView.currentRoute.steps.count > 1) {
        // Only display left right button when steps.count > 1
        [self.navigationItem setRightBarButtonItems:@[rightButton, leftButton] animated:YES];
    } else {
        // Remove all right buttons when steps.count = 1
        [self.navigationItem setRightBarButtonItems:nil animated:NO];
    }
    
    [self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
    
    self.navigationItem.title = [NSString stringWithFormat:@"1 of %li", (unsigned long)self.mapView.currentRoute.steps.count];
}

#pragma mark - Actions

- (void)showNextRouteStep
{
    NSInteger currentStepIndex = [self.mapView.currentRoute.steps indexOfObject:self.mapView.currentStep];
    NSInteger nextStepIndex = currentStepIndex + 1;
    
    if (nextStepIndex < self.mapView.currentRoute.steps.count) {
        PWRouteStep *nextStep = self.mapView.currentRoute.steps[currentStepIndex + 1];
    
        [self.mapView setRouteStep:nextStep];
    
        [self updateRoutingNavBarState];
    } else {
        NSLog(@"No more next step, already last step.");
    }
}

- (void)showPreviousRouteStep
{
    NSInteger currentStepIndex = [self.mapView.currentRoute.steps indexOfObject:self.mapView.currentStep];
    
    if (currentStepIndex == 0) {
        NSLog(@"No more previous step, already first step.");
    } else {
        PWRouteStep *previousStep = self.mapView.currentRoute.steps[currentStepIndex - 1];
        
        [self.mapView setRouteStep:previousStep];
        
        [self updateRoutingNavBarState];
    }
}

- (void)cancelRouting
{
    [self.mapView cancelRouting];
    [self.navigationItem setLeftBarButtonItem:self.directionsBarButton animated:YES];
    
    // Clear the right bar first, otherwise it will have "Previous route step" button
    [self.navigationItem setRightBarButtonItems:nil animated:NO];
    [self.navigationItem setRightBarButtonItem:self.floorSwitchingBarButton animated:YES];
    
    self.navigationItem.title = self.currentBuildingName;
}

- (void)updateRoutingNavBarState
{
    UIBarButtonItem *nextButton = self.navigationItem.rightBarButtonItems[0];
    UIBarButtonItem *previousButton = self.navigationItem.rightBarButtonItems[1];
    
    previousButton.enabled = [self.mapView.currentRoute.steps indexOfObject:self.mapView.currentStep] > 0;
    nextButton.enabled = [self.mapView.currentRoute.steps indexOfObject:self.mapView.currentStep] + 1 < self.mapView.currentRoute.steps.count;
    
    NSInteger currentStepIndex = [self.mapView.currentRoute.steps indexOfObject:self.mapView.currentStep];
    self.navigationItem.title = [NSString stringWithFormat:@"Step %i of %lu", currentStepIndex + 1, (unsigned long)self.mapView.currentRoute.steps.count];
}

@end
