//
//  UIImage+PWMapKit.h
//  PWMapKit
//
//  Created by Illya Busigin on 5/5/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PWMapKit)

+ (UIImage *)_locateMe:(UIColor *)tintColor;
+ (UIImage *)_locateMeFilled:(UIColor *)tintColor;
+ (UIImage *)_trackMe:(UIColor *)tintColor;

@end
