//
//  PWRouteInstruction+Helper.m
//  PWMapKit
//
//  Created on 8/15/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import "PWRouteInstruction+Helper.h"
#import "CommonSettings.h"

@implementation PWRouteInstruction (Helper)

- (BOOL)isFirstInstruction {
    return [[self.route.routeInstructions firstObject] isEqual:self];
}

- (BOOL)isLastInstruction {
    return [[self.route.routeInstructions lastObject] isEqual:self];
}

- (PWRouteInstruction*)previousInstruction {
    if ([self isFirstInstruction]) {
        return nil;
    }
    
    return [self.route.routeInstructions objectAtIndex:([self indexInRoute] - 1)];
}

- (PWRouteInstruction*)nextInstruction {
    if ([self isLastInstruction]) {
        return nil;
    }
    
    return [self.route.routeInstructions objectAtIndex:([self indexInRoute] + 1)];
}

- (BOOL)isFloorChange {
    NSArray *floorChangeDirections = @[@(PWRouteInstructionDirectionStairsUp),
                                       @(PWRouteInstructionDirectionStairsDown),
                                       @(PWRouteInstructionDirectionElevatorUp),
                                       @(PWRouteInstructionDirectionElevatorDown)
                                       ];
    
    return [floorChangeDirections containsObject:@(self.movementDirection)];
}

- (float)turnAngleToFaceHeadingFromCurrentBearing:(CLLocationDirection)bearing {
    CLLocationDirection heading = [self movementTrueHeading];
    return (fmod(fmod((bearing - heading), 360) + 540, 360) - 180) * -1;
}

- (NSUInteger)indexInRoute {
    return [self.route.routeInstructions indexOfObject:self];
}

- (BOOL)isEqualRouteInstruction:(PWRouteInstruction *)object {
    if (!object || !CLLocationCoordinate2DIsValid(object.startPointOfInterest.coordinate) || !CLLocationCoordinate2DIsValid(object.endPointOfInterest.coordinate)) {
        return NO;
    }
    
    if (self.startPointOfInterest.coordinate.latitude == object.startPointOfInterest.coordinate.latitude &&
        self.startPointOfInterest.coordinate.longitude == object.startPointOfInterest.coordinate.longitude &&
        self.endPointOfInterest.coordinate.latitude == object.endPointOfInterest.coordinate.latitude &&
        self.endPointOfInterest.coordinate.longitude == object.endPointOfInterest.coordinate.longitude) {
        return YES;
    }
    
    return NO;
}

@end
