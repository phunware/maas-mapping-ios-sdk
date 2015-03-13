//
//  PWAnnotationLabel.h
//  PWMapKit
//
//  Copyright (c) 2015 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The `PWAnnotationLabel` is a `UILabel` subclass used with annotation views that allows stroke color and width customizations.
 */

@interface PWAnnotationLabel : UILabel

/**
 The stroke color of the text outline.
 */
@property (nonatomic) UIColor *strokeColor;

/**
 The stroke width of the text outline.
 */
@property (nonatomic) CGFloat strokeWidth;

@end
