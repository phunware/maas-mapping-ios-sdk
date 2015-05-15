//
//  PWManeuverListBarButtonItem.m
//  PWMapKit
//
//  Created by Phunware on 4/29/15.
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import "PWManeuverListBarButtonItem.h"

@implementation PWManeuverListBarButtonItem

-(instancetype)initWithTarget:(id)target action:(SEL)selector {
    self = [super initWithImage:[[self class] maneuverListImage:[UIColor whiteColor]] style:UIBarButtonItemStylePlain target:target action:selector];
    return self;
}


+ (UIImage *)maneuverListImage:(UIColor *)tintColor {
    CGRect rect = CGRectMake(0, 0, 26, 26);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    NSUInteger numberLines = 4;
    NSUInteger totalWidthHeight = 26;
    NSUInteger topMargin = 5;
    NSUInteger bottomMargin = 1;
    NSUInteger leftRightMargin = 1;
    NSUInteger startY = topMargin;
    CGFloat stepY = (totalWidthHeight-topMargin-bottomMargin)/numberLines;
    CGFloat longLineWidth = totalWidthHeight-topMargin-bottomMargin;
    CGFloat shortLineWidth = longLineWidth * 0.7;
    
    double currentY = startY;
    for (NSUInteger i = 0; i < 4; i++) {
        [bezierPath moveToPoint: CGPointMake(leftRightMargin, currentY)];
        if (i%2==0) {
            [bezierPath addLineToPoint: CGPointMake(leftRightMargin+longLineWidth, currentY)];
        }else{
            [bezierPath addLineToPoint: CGPointMake(leftRightMargin+shortLineWidth, currentY)];
        }
        [bezierPath closePath];
        currentY += stepY;
    }
    
    [bezierPath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
