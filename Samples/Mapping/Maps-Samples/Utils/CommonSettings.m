//
//  CommonSettings.m
//  PWMapKit
//
//  Created on 8/10/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonSettings.h"

@implementation PWAlertAction

@end

@implementation CommonSettings

#pragma mark - Colors

+ (UIColor *)commonNavigationBarBackgroundColor {
    return [UIColor colorWithRed:0.0118 green:0.3961 blue:0.7529 alpha:1.0];
}

+ (UIColor *)commonNavigationBarForgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)commonViewForgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)commonButtonContainerBackgroundColor {
    return [UIColor colorWithRed:0.9608 green:0.8275 blue:0.1569 alpha:1.0];
}

+ (UIColor *)commonButtonBackgroundColor {
    return [UIColor colorWithRed:0.7647 green:0.5922 blue:0.1020 alpha:1.0];
}

+ (UIColor *)commonToolbarColor {
    return [UIColor colorWithRed:(20.0/255.0) green:(93.0/255.0) blue:(242.0/255.0) alpha:1.0];
}

#pragma mark - Distance Helpers

+ (CLLocationDistance)distanceFrom:(CLLocationCoordinate2D)start to:(CLLocationCoordinate2D)end {
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:start.latitude longitude:start.longitude];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:end.latitude longitude:end.longitude];
    return [startLocation distanceFromLocation:endLocation];
}

+ (double)distanceInFeetFromDistanceInMeters:(CLLocationDistance)distanceInMeters {
    return distanceInMeters * 3.28084;
}

#pragma mark - Images

+ (UIImage *)imageFromDirection:(PWRouteInstructionDirection)direction {
    switch (direction) {
        case PWRouteInstructionDirectionStraight:
            return [UIImage imageNamed:kPWRouteInstructionDirectionStraight];
            break;
        case PWRouteInstructionDirectionLeft:
            return [UIImage imageNamed:kPWRouteInstructionDirectionSharpLeft];
            break;
        case PWRouteInstructionDirectionRight:
            return [UIImage imageNamed:kPWRouteInstructionDirectionSharpRight];
            break;
        case PWRouteInstructionDirectionBearLeft:
            return [UIImage imageNamed:kPWRouteInstructionDirectionBearLeft];
            break;
        case PWRouteInstructionDirectionBearRight:
            return [UIImage imageNamed:kPWRouteInstructionDirectionBearRight];
            break;
        case PWRouteInstructionDirectionElevatorUp:
            return [UIImage imageNamed:kPWRouteInstructionDirectionElevatorUp];
            break;
        case PWRouteInstructionDirectionElevatorDown:
            return [UIImage imageNamed:kPWRouteInstructionDirectionElevatorDown];
            break;
        case PWRouteInstructionDirectionStairsUp:
            return [UIImage imageNamed:kPWRouteInstructionDirectionStairsUp];
            break;
        case PWRouteInstructionDirectionStairsDown:
            return [UIImage imageNamed:kPWRouteInstructionDirectionStairsDown];
            break;
            
        default:
            break;
    }
    
    return nil;
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Constraint Helper

+ (void)changeConstraints:(NSLayoutAttribute)attribute value:(CGFloat)value forView:(UIView *)view {
    for (NSLayoutConstraint *cons in view.superview.constraints) {
        if ([[cons.firstItem class] isSubclassOfClass:[view class]] && cons.firstAttribute == attribute) {
            cons.constant = value;
            [view layoutIfNeeded];
        }
    }
}

+ (UIAlertController *)buildActionSheetWithItems:(NSArray *)items displayProperty:(NSString *)displayProperty selectedItem:(id)selectedItem title:(NSString *)title actionNameFormat:(NSString *)format topAction:(NSString *)topAction selectAction:(void(^)(id selection))selectAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (topAction) {
        NSString *topActionTitle = topAction;
        if (!selectedItem) {
            topActionTitle = [NSString stringWithFormat:@"✔︎ %@", topAction];
        }
        PWAlertAction *action = [PWAlertAction actionWithTitle:topActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            if (selectAction) {
                selectAction(nil);
            }
        }];
        
        action.carrier = nil;
        [alert addAction:action];
    }
    
    for (id item in items) {
        id actionTitle = displayProperty ? [item valueForKey:displayProperty] : [item stringValue];
        id currentValue = displayProperty ? [selectedItem valueForKey:displayProperty] : [selectedItem stringValue];
        
        BOOL match = NO;
        if ([actionTitle isKindOfClass:[NSString class]]) {
            match = [actionTitle isEqualToString:currentValue];
        } else {
            match = (actionTitle == currentValue);
        }
        
        if (format) {
            actionTitle = [NSString stringWithFormat:format, actionTitle];
        }
        
        if (match) {
            actionTitle = [NSString stringWithFormat:@"✔︎ %@", actionTitle];
        } else {
            actionTitle = [NSString stringWithFormat:@"%@", actionTitle];
        }
        
        PWAlertAction *action = [PWAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            if (selectAction) {
                selectAction(((PWAlertAction*)action).carrier);
            }
        }];
        
        action.carrier = item;
        [alert addAction:action];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:PWLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}]];
    
    return alert;
}

@end
