//
//  PWAnnotationLabel.h
//  PWMapKit
//
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The `PWAnnotationLabel` is a `UILabel` subclass that allows stroke color and stroke width customizations.
 */

@interface PWAnnotationLabel : UILabel

/**
 The stroke color of the text outline.
 */
@property (nonatomic, strong) UIColor *strokeColor;

/**
 The stroke width of the text outline.
 */
@property (nonatomic, assign) CGFloat strokeWidth;

@end
