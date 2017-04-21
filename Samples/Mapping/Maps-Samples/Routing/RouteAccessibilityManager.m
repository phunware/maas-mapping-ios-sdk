//
//  RouteAccessibilityManager.m
//  Maps-Samples
//
//  Created on 9/26/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <PWMapKit/PWMapKit.h>

#import "RouteAccessibilityManager.h"
#import "MapViewController.h"
#import "CommonSettings.h"
#import "PWIndoorLocation+Helper.h"
#import "PWRouteInstruction+Helper.h"

#define kUpdateFrequency 2
#define kDistanceToTellInstructionWillChange 6
#define kDistanceToTellLongWayUpdate 15

@interface RouteAccessibilityManager()

@property (nonatomic) id accessibilityArgument;
@property (nonatomic, strong) PWIndoorLocation *currentLocation;
@property (nonatomic, strong) CLHeading *currentHeading;
// The `PWRouteInstruction` which was notified about to change.
@property (nonatomic, strong) PWRouteInstruction *notifiedRouteInstructionAboutChange;
@property (nonatomic) CLLocationDistance previousNotifiedDistance;
@property (nonatomic) BOOL isRouteFinished;

@end

@implementation RouteAccessibilityManager

#pragma mark - Initial & Instance

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation:) name:CurrentUserLocationUpdatedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeading:) name:CurrentUserHeadingUpdatedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInstruction:) name:PWRouteInstructionChangedNotificationKey object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyShowRoute:) name:PlotRouteNotification object:nil];
    }
    
    return self;
}

+ (RouteAccessibilityManager*)sharedInstance {
    static RouteAccessibilityManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [RouteAccessibilityManager new];
    });
    
    return shared;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

/**
 Update based on user's location update, VO may be:
 1. Arrive destination:
    VO: You have arrived at your destination.
 2. About to change to next instruction:
    VO: Turn to your 3 o' clock.
    VO: Take stair to floor 2.
    VO: Take elevator to floor 2.
 3. Long distance report:
    VO: Continue 120 foot.
 */
- (void)updateLocation:(NSNotification *)notification {
    if (_isRouteFinished && !notification.object)
        return;
    
    // Set latest location
    _currentLocation = notification.object;
    if (!_currentRouteInstruction)
        return;
    
    CLLocationDistance distanceToEndPoint = [_currentLocation distanceTo:_currentRouteInstruction.route.endPoint.coordinate];
    // Check if user is about to end current instruction
    if (distanceToEndPoint < kDistanceToTellInstructionWillChange) {
        // Check to avoid repeating
        if ([_currentRouteInstruction isEqual:_notifiedRouteInstructionAboutChange])
            return;
        
        _notifiedRouteInstructionAboutChange = _currentRouteInstruction;
        
        if ([_currentRouteInstruction isLastInstruction]) {
            // Mark the route is finished
            _isRouteFinished = YES;
            
            // Last instruction: notify arrive destination
            NSString *accessibilityLabel = PWLocalizedString(@"DestinationArrived", @"You have arrived at your destination.");
            if ([self.delegate respondsToSelector:@selector(routeInstruction:arrivingDestination:)]) {
                [self.delegate routeInstruction:_currentRouteInstruction arrivingDestination:accessibilityLabel];
            }
            
            // To cancel the route - temporarily use notification to cancel current route
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:CancelCurrentRouteNotification object:nil];
            });
        } else {
            // Notifiy it's about finish current instruction
            if (_currentRouteInstruction.distance >= kDistanceToTellInstructionWillChange) {
                // Notify only when the distance of instruction is more than `kDistanceToTellInstructionWillChange`
                NSString *accessibilityLabel = [self instructionChangeFormat:_currentRouteInstruction];
                if ([self.delegate respondsToSelector:@selector(routeInstruction:willEndRouteInstructionVO:)]) {
                    [self.delegate routeInstruction:_currentRouteInstruction willEndRouteInstructionVO:accessibilityLabel];
                }
            }
        }
    } else {
        if ([_currentRouteInstruction isEqual:_notifiedRouteInstructionAboutChange]) {
            // User went back when it's about to change instruction 
            if ([self.delegate respondsToSelector:@selector(shouldResetRouteInstruction:)]) {
                [self.delegate shouldResetRouteInstruction:_currentRouteInstruction];
            }
        }
        _notifiedRouteInstructionAboutChange = nil;
        
        CLLocationDistance distanceToStartPoint = [_currentLocation distanceTo:_currentRouteInstruction.route.startPoint.coordinate];
        // Check if it's time to tell the rest of distance
        if (distanceToStartPoint > _previousNotifiedDistance) {
            _previousNotifiedDistance = distanceToStartPoint + kDistanceToTellLongWayUpdate;
            
            CLLocationDistance restDistance = [_currentLocation distanceTo:_currentRouteInstruction.route.endPoint.coordinate];
            NSString *accessibilityLabel = [NSString stringWithFormat:PWLocalizedString(@"ContinueXFeetThenTurnToXOClock", @"continue %@."), [self distanceFormat:restDistance]];
            if ([self.delegate respondsToSelector:@selector(routeInstruction:didLongDistanceMoveVO:)]) {
                [self.delegate routeInstruction:_currentRouteInstruction didLongDistanceMoveVO:accessibilityLabel];
            }
        }
    }
}

/**
 Orientation changed:
    VO: Turn to your 3 o' clock.
 */
- (void)updateHeading:(NSNotification *)notification {
    if (_isRouteFinished && !notification.object)
        return;
    
    // Set latest heading
    _currentHeading = notification.object;
    
    float angleBetweenHeadingAndInstruction = [_currentRouteInstruction turnAngleToFaceHeadingFromCurrentBearing:_currentHeading.trueHeading];
    NSString *accessibilityLabel = [self orientationFormat:angleBetweenHeadingAndInstruction];
    BOOL isRightOrientation = ([self clockDirectionFromAngle:angleBetweenHeadingAndInstruction].integerValue == 12);
    if ([self.delegate respondsToSelector:@selector(routeInstruction:didChangeOrientationVO:onRightOrientation:)]) {
        [self.delegate routeInstruction:_currentRouteInstruction didChangeOrientationVO:accessibilityLabel onRightOrientation:isRightOrientation];
    }
}

/**
 Notifiy started a new instruction, VO may be:
 1. Orentation is right:
    VO: Go straight 10 foot.
 2. Orentation is not right:
    VO: Turn to your 10 o' clock, then go straight 10 foot.
 */
- (void)updateInstruction:(NSNotification *)notification {
    if (_isRouteFinished && !notification.object) {
        return;
    }
    
    if (!_currentRouteInstruction && _currentHeading) {
        NSNotification *headingNotification = [NSNotification notificationWithName:CurrentUserHeadingUpdatedNotification object:_currentHeading userInfo:nil];
        [self updateHeading:headingNotification];
    }
    
    if ([(PWRouteInstruction *)notification.object isEqualRouteInstruction:_currentRouteInstruction]) {
        // SDK issue causes it may be notified multiple times
        return;
    }
    
    // Reset the previous route instruction
    if ([self.delegate respondsToSelector:@selector(shouldResetRouteInstruction:)]) {
        [self.delegate shouldResetRouteInstruction:_currentRouteInstruction];
    }
    
    // Set latest route instruction
    _currentRouteInstruction = notification.object;
    
    // Reset the notified distance
    _previousNotifiedDistance = kDistanceToTellLongWayUpdate;
    
    NSString *orientationAccessibilityLabel = nil;
    if (_currentHeading) {
        float angleBetweenHeadingAndInstruction = [_currentRouteInstruction turnAngleToFaceHeadingFromCurrentBearing:_currentHeading.trueHeading];
        if ([self clockDirectionFromAngle:angleBetweenHeadingAndInstruction].integerValue != 12) {
            // Get orientation if it is not right currently
            orientationAccessibilityLabel = [self orientationFormat:angleBetweenHeadingAndInstruction];
        }
    }
    
    NSString *accessibilityLabel = [NSString stringWithFormat:PWLocalizedString(@"GoStraightForXThenX", @"go straight for %@, then %@."), [self distanceFormat:_currentRouteInstruction.distance], [self instructionChangeFormat:_currentRouteInstruction]];
    
    if ([self.delegate respondsToSelector:@selector(routeInstruction:didStartRouteInstructionVO:)]) {
        [self.delegate routeInstruction:_currentRouteInstruction didStartRouteInstructionVO:accessibilityLabel];
    }
}

- (void)notifyShowRoute:(NSNotification *)notification {
    _currentRouteInstruction = nil;
    _isRouteFinished = NO;
}

#pragma mark - Private

- (NSString *)distanceFormat:(CLLocationDistance)meter {
    int distanceIntValue = 0;
    BOOL distanceIsOne = NO;
    if (_locationDistanceUnit == LocationDistanceUnitFeet) {
        distanceIntValue = (int)roundf(feetFromMeter(meter));
        distanceIsOne = distanceIntValue == 1;
        return [NSString stringWithFormat:@"%d %@", distanceIntValue, distanceIsOne?@"foot":@"feet"];
    } else {
        distanceIntValue = (int)roundf(meter);
        distanceIsOne = distanceIntValue == 1;
        return [NSString stringWithFormat:@"%d %@", distanceIntValue, distanceIsOne?@"meters":@"meter"];
    }
}

- (NSString *)orientationFormat:(CLLocationDirection)direction {
    if (_directionType == DirectionTypeOClock) {
        NSNumber *clock = [self clockDirectionFromAngle:direction];
        return [NSString stringWithFormat:@"turn to your %@ o'clock", clock];
    } else {
        if (ABS(direction) > 45) {
            if (direction > 0) {
                return @"turn right";
            } else {
                return @"turn left";
            }
        } else if (ABS(direction) > 22.5) {
            if (direction > 0) {
                return @"bear right";
            } else {
                return @"bear left";
            }
        }
    }
    
    return nil;
}

- (NSString *)instructionChangeFormat:(PWRouteInstruction *)instruction {
    NSString *accessibilityLabel;
    
    if ([instruction isLastInstruction]) {
        // Last instruction: notify arrive destination
        accessibilityLabel = PWLocalizedString(@"DestinationArrived", @"You will arrive at your destination.");
    } else if([[instruction nextInstruction] isFloorChange]) {
        // Change floor
        accessibilityLabel = [instruction nextInstruction].movement;
    } else {
        // Notifiy it's about finish current instruction
        accessibilityLabel = [self orientationFormat:instruction.turnAngle];
    }
    
    return accessibilityLabel;
}

- (NSNumber *)clockDirectionFromAngle:(float)angle {
    NSNumber *clockDirection = @12;
    
    if (angle < -165 || angle > 165) {
        clockDirection = @6;
    } else if (angle > -165 && angle < -135) {
        clockDirection = @7;
    } else if (angle > -135 && angle < -105) {
        clockDirection = @8;
    } else if (angle > -105 && angle < -75) {
        clockDirection = @9;
    } else if (angle > -75 && angle < -35) {
        clockDirection = @10;
    } else if (angle > -35 && angle < -15) {
        clockDirection = @11;
    } else if (angle > -15 && angle < 15) {
        clockDirection = @12;
    } else if (angle > 15 && angle < 35) {
        clockDirection = @1;
    } else if (angle > 35 && angle < 75) {
        clockDirection = @2;
    } else if (angle > 75 && angle < 105) {
        clockDirection = @3;
    } else if (angle > 105 && angle < 135) {
        clockDirection = @4;
    } else if (angle > 135 && angle < 165) {
        clockDirection = @5;
    }
    
    return clockDirection;
}

@end
