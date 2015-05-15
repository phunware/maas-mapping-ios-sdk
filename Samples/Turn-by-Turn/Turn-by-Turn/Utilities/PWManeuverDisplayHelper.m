//
//  PWManeuverDisplayHelper.m
//  Turn-by-Turn
//
//  Created by Phunware on 4/29/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import "PWManeuverDisplayHelper.h"
#import "PWConstants.h"

typedef NS_ENUM(NSUInteger, PWManeuverDisplayHelperFloorChangeDirection) {
    PWManeuverDisplayHelperFloorChangeDirectionSameFloor,
    PWManeuverDisplayHelperFloorChangeDirectionUp,
    PWManeuverDisplayHelperFloorChangeDirectionDown
};


@implementation PWManeuverDisplayHelper

#pragma mark - Public methods

+ (NSString*)descriptionForManeuver:(PWRouteManeuver*)maneuver inMapView:(PWMapView*)mapview {
    NSMutableString * description = [NSMutableString new];
    switch (maneuver.direction) {
        case PWRouteManeuverDirectionStraight:{
            [description appendString:@"Continue straight for"];
            break;
        }
        case PWRouteManeuverDirectionBearLeft:{
            [description appendString:@"Bear left for"];
            break;
        }
        case PWRouteManeuverDirectionBearRight:{
            [description appendString:@"Bear right for"];
            break;
        }
        case PWRouteManeuverDirectionLeft:{
            [description appendString:@"Turn left"];
            break;
        }
        case PWRouteManeuverDirectionRight:{
            [description appendString:@"Turn right"];
            break;
        }
        case PWRouteManeuverDirectionFloorChange:
        {
            [description appendString:[self floorChangeDescriptionForManeuver:maneuver inMapView:mapview]];
            break;
        }
        default: break;
    }
    
    if (maneuver.direction == PWRouteManeuverDirectionStraight
        || maneuver.direction == PWRouteManeuverDirectionBearLeft
        || maneuver.direction == PWRouteManeuverDirectionBearRight )
    {
        [description appendString:@" "];
        [description appendString:[self distanceStringUsingDistance:maneuver.distance]];
    }
    
    if (!maneuver.nextManeuver) {
        id<PWDirectionsWaypointProtocol> lastPoint = [maneuver points].lastObject;
        if ([lastPoint conformsToProtocol:@protocol(MKAnnotation)] &&
            [(id<MKAnnotation>)lastPoint title])
        {
            id<PWAnnotationProtocol> lastAnnotation = (id<PWAnnotationProtocol>)lastPoint;
            [description appendFormat:@" to arrive at %@",[lastAnnotation title]];
        }else{
            [description appendString:@" to arrive at your destination"];
        }
    }
    
    return description.copy;
}

+ (NSString*)destinationImageNameWithLastManeuver:(PWRouteManeuver*)maneuver {
    return @"destination_pin.png";
}

+ (NSString*)imageNameForManeuver:(PWRouteManeuver*)maneuver inMapView:(PWMapView*)mapview {
    NSString *imageName = nil;
    if (maneuver) {
        switch (maneuver.direction) {
            case PWRouteManeuverDirectionStraight:{
                imageName = @"straight.png";
                break;
            }
            case PWRouteManeuverDirectionBearLeft:{
                imageName = @"slightleft.png";
                break;
            }
            case PWRouteManeuverDirectionBearRight:{
                imageName = @"slightright.png";
                break;
            }
            case PWRouteManeuverDirectionLeft:{
                imageName = @"sharpleft.png";
                break;
            }
            case PWRouteManeuverDirectionRight: {
                imageName = @"sharpright.png";
                break;
            }
            case PWRouteManeuverDirectionFloorChange:{
                id<PWDirectionsWaypointProtocol> waypoint = maneuver.points.lastObject;
                if ([waypoint conformsToProtocol:@protocol(PWAnnotationProtocol)]) {
                    id<PWAnnotationProtocol> annotation = (id<PWAnnotationProtocol>) waypoint;
                    if ([annotation.title.lowercaseString rangeOfString:@"elevator"].location != NSNotFound) {
                        
                        PWManeuverDisplayHelperFloorChangeDirection direction = [self directionForManeuver:maneuver inMapView:mapview];
                        if (direction == PWManeuverDisplayHelperFloorChangeDirectionUp) {
                            imageName = @"elevator_up.png";
                        }else if (direction == PWManeuverDisplayHelperFloorChangeDirectionDown) {
                            imageName = @"elevator_down.png";
                        }else{
                            imageName = @"elevator.png";
                        }
                        return imageName;
                    }
                }
                
                PWManeuverDisplayHelperFloorChangeDirection direction = [self directionForManeuver:maneuver inMapView:mapview];
                if (direction == PWManeuverDisplayHelperFloorChangeDirectionUp) {
                    imageName =  @"stairs_up.png";
                }else if (direction == PWManeuverDisplayHelperFloorChangeDirectionDown) {
                    imageName =  @"stairs_down.png";
                }else{
                    imageName =  @"stairs.png";
                }
                break;
            }
            default: break;
        }
    }
    return imageName;
}

#pragma mark - Private methods

+ (PWManeuverDisplayHelperFloorChangeDirection)directionForManeuver:(PWRouteManeuver*)maneuver inMapView:(PWMapView*)mapview {
    id<PWDirectionsWaypointProtocol> startPoint = maneuver.points.firstObject;
    PWBuildingFloor *currentFloor = [self buildingFloorForMap:mapview andFloorIdentifier:startPoint.floorID];
    id<PWDirectionsWaypointProtocol> endPoint = maneuver.points.lastObject;
    PWBuildingFloor *nextFloor = [self buildingFloorForMap:mapview andFloorIdentifier:endPoint.floorID];
    
    if (currentFloor.floorLevel < nextFloor.floorLevel){
        return PWManeuverDisplayHelperFloorChangeDirectionUp;
    }else if (currentFloor.floorLevel > nextFloor.floorLevel){
        return PWManeuverDisplayHelperFloorChangeDirectionDown;
    }else{
        return PWManeuverDisplayHelperFloorChangeDirectionSameFloor;
    }
}

+ (NSString*)floorChangeDescriptionForManeuver:(PWRouteManeuver*)maneuver inMapView:(PWMapView*)mapview {
    id<PWDirectionsWaypointProtocol> endPoint = maneuver.points.lastObject;
    PWBuildingFloor *nextFloor = [self buildingFloorForMap:mapview andFloorIdentifier:endPoint.floorID];
    
    NSMutableString *descriptionString = @"".mutableCopy;
    NSString *firstSentencePart = @"Go";
    
    id<PWDirectionsWaypointProtocol> waypoint = maneuver.points.lastObject;
    if ([waypoint conformsToProtocol:@protocol(PWAnnotationProtocol)]) {
        id<PWAnnotationProtocol> annotation = (id<PWAnnotationProtocol>) waypoint;
        if ([annotation.title.lowercaseString rangeOfString:@"elevator"].location != NSNotFound) {
             firstSentencePart = @"Take the elevator";
        }
        if ([annotation.title.lowercaseString rangeOfString:@"stairs"].location != NSNotFound) {
            firstSentencePart = @"Take the stairs";
        }
    }
    
    PWManeuverDisplayHelperFloorChangeDirection direction = [self directionForManeuver:maneuver inMapView:mapview];
    
    if (direction==PWManeuverDisplayHelperFloorChangeDirectionUp){
        [descriptionString appendFormat:@"%@ up to ",firstSentencePart];
    }else if (direction==PWManeuverDisplayHelperFloorChangeDirectionDown){
        [descriptionString appendFormat:@"%@ down to ",firstSentencePart];
    }else{
        [descriptionString appendFormat:@"%@ to ",firstSentencePart];
    }
    [descriptionString appendFormat:@"%@",nextFloor.name];
    return descriptionString.copy;
}

+ (PWBuildingFloor*)buildingFloorForMap:(PWMapView*)mapview andFloorIdentifier:(PWBuildingFloorIdentifier)floorId {
    return [[mapview building] floorForIdentifier:floorId];
}

+ (NSString*)distanceStringUsingDistance:(CLLocationDistance)distance {
    NSMutableString *distanceString = [NSMutableString string];
    CLLocationDistance displayedDistance;
    if ([self usingImperialUnits]) {
        displayedDistance = distance * 3.28084; // meters to feet
    } else {
        displayedDistance = distance;
    }
    [distanceString appendFormat:@"%@ ",[[self distanceFormatter] stringFromNumber:@(displayedDistance)]];
    
    if (ceil(displayedDistance) != 1) {
        [distanceString appendFormat:[self usingImperialUnits]?@"feet":@"meters"];
    } else {
        [distanceString appendFormat:[self usingImperialUnits]?@"foot":@"meter"];
    }
    return distanceString.copy;
}

+ (NSNumberFormatter *)distanceFormatter {
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSNumberFormatter *standardDistanceFormatter = [threadDictionary objectForKey:@"com.phunware.mapsample.distance-formatter"];
    
    if (standardDistanceFormatter == nil) {
        standardDistanceFormatter = [NSNumberFormatter new];
        standardDistanceFormatter.formatterBehavior = NSNumberFormatterBehavior10_4;
        standardDistanceFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        standardDistanceFormatter.roundingMode = NSNumberFormatterRoundCeiling;
        standardDistanceFormatter.maximumFractionDigits = 0;
        [threadDictionary setObject:standardDistanceFormatter forKey:@"com.phunware.mapsample.distance-formatter"];
    }
    
    return standardDistanceFormatter;
}

+ (BOOL)usingImperialUnits {
    NSString *currentUnitsSelection = [[NSUserDefaults standardUserDefaults] objectForKey:PWUnitDisplayTypeUserDefaultsKey];
    if ([currentUnitsSelection isEqualToString:PWUnitDisplayTypeUserMetricKey]) {
        return NO;
    }
    
    return YES;
}

@end
