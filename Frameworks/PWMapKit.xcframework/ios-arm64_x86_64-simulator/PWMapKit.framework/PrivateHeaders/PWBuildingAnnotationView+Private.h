//
//  PWBuildingAnnotationView+Private.h
//  PWMapKit
//
//  Created by Illya Busigin on 8/6/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "PWBuildingAnnotationView.h"

@interface PWBuildingAnnotationView ()

@property (nonatomic, nullable, strong) NSLayoutConstraint *imageWidthConstraint;

- (CGFloat)imageWidth;
- (CGFloat)annotationWidth;

@end
