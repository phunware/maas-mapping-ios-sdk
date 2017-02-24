//
//  CommonSettings.h
//  PWMapKit
//
//  Created on 8/10/16.
//  Copyright © 2016 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <PWMapKit/PWMapKit.h>

#define kStandardIconSize 32.0
#define kStandardSpace 10.0
#define kStandardLineSpace 5.0
#define kHorizontalOffset 15.0
#define kVerticalOffset 15.0
#define kDefaultSearchRadius @(25)
#define kViewRefreshInterval 2

#define filterDistance() @[@(10), @(15), @(20), @(25), @(30), @(35), @(40), @(45), @(50)]

#define feetFromMeter(meter) meter*3.28084
#define meterFromFeet(feet) feet*0.3048
#define PWLocalizedString(key, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:(comment) table:nil]

@class UIColor;

@interface PWAlertAction : UIAlertAction

@property (nonatomic) id carrier;

@end

@interface CommonSettings : NSObject

#pragma mark - Colors

+ (UIColor *)commonNavigationBarBackgroundColor;
+ (UIColor *)commonNavigationBarForgroundColor;
+ (UIColor *)commonViewForgroundColor;
+ (UIColor *)commonButtonContainerBackgroundColor;
+ (UIColor *)commonButtonBackgroundColor;
+ (UIColor *)commonToolbarColor;

#pragma mark - Distance Helpers

+ (CLLocationDistance)distanceFrom:(CLLocationCoordinate2D)start to:(CLLocationCoordinate2D)end;
+ (double)distanceInFeetFromDistanceInMeters:(CLLocationDistance)distanceInMeters;

#pragma mark - Images

+ (UIImage *)imageFromDirection:(PWRouteInstructionDirection)direction;
+ (UIImage *)imageFromColor:(UIColor *)color;

#pragma mark - Constraint Helper

+ (void)changeConstraints:(NSLayoutAttribute)attribute value:(CGFloat)value forView:(UIView *)view;

+ (UIAlertController *)buildActionSheetWithItems:(NSArray *)items displayProperty:(NSString *)displayProperty selectedItem:(id)selectedItem title:(NSString *)title actionNameFormat:(NSString *)format topAction:(NSString *)topAction selectAction:(void(^)(id selection))selectAction;

@end
